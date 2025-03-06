library(rpart)
library(ggplot2)
library(jsonlite)

gbm_fit <- function(X, y, objective, M = 100, learning_rate = 0.1, max_depth = 1) {
  get_optimal_base_value <- function(y, loss) {
    c_values <- seq(min(y), max(y), length.out = 100)
    losses <- sapply(c_values, function(c) loss(y, rep(c, length(y))))
    c_values[which.min(losses)]
  }
  
  get_optimal_leaf_value <- function(y, current_predictions, loss) {
    if (length(y) == 0) {
      stop("No samples in this leaf. Cannot compute optimal leaf value.")
    }
    c_values <- seq(-1, 1, length.out = 100)
    losses <- sapply(c_values, function(c) loss(y, current_predictions + c))
    optimal_value <- c_values[which.min(losses)]
    return(optimal_value)
  }
  
  update_terminal_nodes <- function(tree, X, y, current_predictions, loss) {
    leaf_nodes <- which(tree$frame$var == "<leaf>")
    leaf_node_for_each_sample <- as.numeric(predict(tree, data.frame(X), type = "matrix"))
    
    for (leaf in leaf_nodes) {
      samples_in_this_leaf <- which(leaf_node_for_each_sample == leaf)
      if (length(samples_in_this_leaf) == 0) {
        next
      }
      y_in_leaf <- y[samples_in_this_leaf]
      preds_in_leaf <- current_predictions[samples_in_this_leaf]
      val <- get_optimal_leaf_value(y_in_leaf, preds_in_leaf, loss)
      tree$frame$yval[leaf] <- val
    }
    tree
  }
  
  base_prediction <- get_optimal_base_value(y, objective$loss)
  current_predictions <- rep(base_prediction, length(y))
  
  predictions <- list()
  predictions[[1]] <- current_predictions
  trees <- list()
  residual_predictions <- list()
  for (i in 1:M) {
    pseudo_residuals <- objective$negative_gradient(y, current_predictions)
    tree <- rpart(pseudo_residuals ~ ., data = data.frame(X, pseudo_residuals), 
                  method = "anova", maxdepth = max_depth)
    tree <- update_terminal_nodes(tree, X, y, current_predictions, objective$loss)
    res_pred <- predict(tree, data.frame(X))
    current_predictions <- current_predictions + learning_rate * res_pred
    residual_predictions[[i]] <-  res_pred
    predictions[[i+1]] <- current_predictions
    trees[[i]] <- tree
  }
  
  list(trees = trees, base_prediction = base_prediction, learning_rate = learning_rate, predictions=predictions, residual_predictions = residual_predictions)
}

gbm_predict <- function(model, X) {
  predictions <- model$base_prediction + model$learning_rate * Reduce(
    `+`, lapply(model$trees, function(tree) predict(tree, data.frame(X)))
  )
  predictions
}






make_test_data <- function(n, noise_scale, outlier_fraction = 0.2) {
  x <- matrix(seq(0, 10, length.out = n), ncol = 1)
  y <- sin(x) + rnorm(n, 0, 0.1)
  
  # Introduce outliers
  n_outliers <- ceiling(n * outlier_fraction)
  if (n_outliers > 0) {
    outlier_indices <- sample(seq_len(n), n_outliers)
    y[outlier_indices] <- y[outlier_indices] + rnorm(n_outliers, 0, 5 * noise_scale)  # Large noise for outliers
  }
  
  data.frame(x = x, y = y)
}








set.seed(18)

n <- 500
data1 <- make_test_data(n, 0.5,0)
X1 <- data1$x
y1 <- data1$y


true_data <- data.frame(x = seq(0, 10, length.out = n), y = sin(seq(0, 10, length.out = n)))
ggplot(data.frame(data1), aes(x = x, y = y)) +
  geom_point(aes(y = y1), alpha = 0.5, color = "black") +
  geom_line(data = true_data, aes(x = x, y = y), color = "red", size = 1) +
  ggtitle("Test Data 1 Plot") +
  xlab("X") +
  ylab("Y")



ls_objective <- list(
  loss = function(y, pred) mean(0.5*(y - pred)^2),
  negative_gradient = function(y, pred) y - pred
)


model <- gbm_fit(X1, y1, ls_objective, M = 50, learning_rate = 0.1, max_depth = 4)
predictions <- gbm_predict(model, X1)
loss <- ls_objective$loss(y1, predictions)
cat("Loss =", loss)


df <- data.frame(x = X1, y = y1, pred = predictions)
ggplot(df, aes(x = x)) +
  geom_point(aes(y = y), alpha = 0.5, color = "black") +
  geom_line(aes(y = pred), color = "red", size = 1) +
  labs(title = paste("Custom GBM, LS loss = " ,loss),
       x = "X", y = "Y") +
  theme_minimal()



""" Example of how to plot residual predictions and predictions at a given step
model$residual_predictions[2]
df <- data.frame(x = X1, y = y1, pred = unlist(model$residual_predictions[1]))
ggplot(df, aes(x = x)) +
  geom_point(aes(y = y), alpha = 0.5, color = "black") +
  geom_line(aes(y = pred), color = "red", size = 1) +
  labs(title = paste("Custom GBM, LS loss = " ,loss),
       x = "X", y = "Y") +
  theme_minimal()

df <- data.frame(x = X1, y = y1, pred = unlist(model$predictions[1]))
ggplot(df, aes(x = x)) +
  geom_point(aes(y = y), alpha = 0.5, color = "black") +
  geom_line(aes(y = pred), color = "red", size = 1) +
  labs(title = paste("Custom GBM, LS loss = " ,loss),
       x = "X", y = "Y") +
  theme_minimal()
"""


# Exporting to json
export_data <- list(
  predictions = lapply(model$predictions, function(p) as.vector(p)),
  residual_predictions = lapply(model$residual_predictions, function(p) as.vector(p)),
  X1 = lapply(X1, function(p) as.vector(p)),
  y1 = lapply(y1, function(p) as.vector(p))
)

write_json(export_data, "gbm_predictions.json", pretty = TRUE, auto_unbox = TRUE)

