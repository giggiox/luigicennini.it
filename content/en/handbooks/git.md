---
title: "Git Workflows"
date: 2025-01-10T19:53:33+05:30
draft: false
author: "Luigi"
tags:
  - handbooks
image: /projects/git/gitcopertina1.png
description: ""
toc: true
mathjax: true
---


{{< rawhtml >}}

<style>
.tooltip-inner {
	text-align: left;
    white-space: pre-line;
	max-width: 30em;
}

.carousel-control-prev-icon,
.carousel-control-next-icon {
    background-color: black;
}

.carousel-indicators [data-bs-target] {
    background-color: #000; /* Colore degli indicatori (nero) */
    border-radius: 50%; /* Forma circolare */
    width: 10px; /* Larghezza dell'indicatore */
    height: 10px; /* Altezza dell'indicatore */
    opacity: 0.5; /* Trasparenza per indicatori non attivi */
    border: none; /* Rimuove il bordo quadrato */
}

.carousel-indicators [data-bs-target].active {
    opacity: 1; /* Opacità per l'indicatore attivo */
}

/* Posizionamento delle frecce */
.carousel-control-prev,
.carousel-control-next {
    width: 5%; /* Regola la larghezza delle frecce */
}

.carousel-item {
    transition: none !important; /* Disabilita la transizione */
}

.carousel-item.active {
    display: block; /* Assicurati che l'immagine attiva sia mostrata */
}

.carousel-item-next,
.carousel-item-prev,
.carousel-item.active {
    display: block; /* Assicura che le immagini siano visibili */
}



/* Stile per il tag <summary> */
summary {
  font-weight: bold; /* Testo in grassetto */
  cursor: pointer; /* Mostra il cursore come una mano */
  padding: 5px; /* Spaziatura interna */
  list-style: none; /* Rimuovi lo stile predefinito del marker */
}

/* Aggiungi una freccia per indicare lo stato chiuso */
summary::marker {
  content: "▶ "; /* Freccia orientata verso destra */
}

/* Stile per <summary> quando il <details> è aperto */
details[open] > summary::marker {
  content: "▼ "; /* Freccia orientata verso il basso */
}



details {
  border-radius: 5px;
  // margin-left: 20px;
}

details details {
  margin-left: calc(20px * 1);
}

details details details {
  margin-left: calc(20px * 2);
}

.navbar-brand img{
	filter: none;
	mix-blend-mode: normal;
}
.featured-image img{
	filter: none;
	mix-blend-mode: normal;
}
body img{
    filter: invert(100%);
    mix-blend-mode: difference;
    background-color: #18191A; /* Questo diventa il nuovo "bianco" */
}


</style>

    
{{< /rawhtml >}}


In this project, I want to create a visual guide to better understand Git operations. 
While learning how to effectively work with Git, I realized that seeing what happens visually when running Git commands helps solidify the concepts. 

Check out the following links:
1. A fantastic tool for seeing Git commands in action with a visual representation:  [link](https://git-school.github.io/visualizing-git/)
2. A humorous and practical guide for fixing Git mistakes quickly and effectively: [link](https://ohshitgit.com/)




{{< rawhtml >}}
<div id="collapse-all">
    <div class="container text-end"> 
        <div class="row">
            <div class="col-12">
                <span id="toggleAll" style="cursor: pointer;">
                    ▶ Expand All
                </span>
            </div>
        </div>
    </div>
{{< /rawhtml >}}



# Working with Git locally

{{< rawdetails title="create first (and second) commit">}}
Git is a version control system that let's you track files with the (what so called) commits.
To understand what a commit is you first have to understand what these commands are:

1. `git init`

Think of this as setting the stage. When you run git init in your project's directory, you’re creating a new Git repository. 
This tells Git to start tracking changes in your files. 
It’s the first step in bringing your project under version control.

```bash
git init
```


2. `git add`

Now that your repository is set up, it’s time to decide what changes you want to track. 
The `git add .` command stages all changes in your current directory for the next commit. 
Whether you’ve created new files, updated existing ones, or deleted something, this command ensures Git knows about it.

```bash
git add .
```

The `.` after `git add` means "track every file in the repository" (expect the one specified in `.gitignore`).
If you only want to track specific files or directorys, you can do:

```bash
git add /path/to/file
git add /path/to/dir/
```


3. `git commit`

Staging changes is great, but to make them permanent in Git’s history, you need to commit. 
The git commit command saves a snapshot of your staged changes. 
It also requires a message describing what you’ve done, like this:

```bash
git commit -m "first commit"
```



### Example, create first and second commit

Below here an example on how to start a repository and what happens graphically:

```bash
git init # Initialize empty git repository

# First commit
echo "i'm Luigi" > file1.txt # Create first file
git add . # Stage content
git commit -m "first commit" # Create first commit


# Second commit
echo "ciao!" >> file1.txt
git add .
git commit -m "second commit"
```
{{< carousel path="projects/git/commit/images/" >}}


### What is master and HEAD
Master and HEAD are both references.
In the example above, HEAD reference always points to master branch reference.
You can run:
```
$ cat .git/HEAD
ref: refs/heads/master
```
Where you see that HEAD points to master branch reference.
In the other hand, the master reference points to the most recent commit sha.
```
$ cat .git/refs/heads/master
b9b394fb13ea56880d3d49b5a87bc8a19cdb8ab2
```


{{< endrawdetails >}}






{{< rawdetails title="git branch - create (and delete) branches">}}
Creating branches in Git is a key part of working effectively with version control. 
A branch lets you diverge from the main codebase to experiment, add features, or fix bugs without affecting the stable version of your project.
To create a new branch reference pointing to the current commit, use the git branch <branch-name> command.

```bash
git branch crazyFeature
```
This command creates a branch named crazyFeature at the current commit, but it doesn’t switch you to the new branch immediately. 
Instead, it simply adds a new pointer to your branch history.

Graphically, it can be seen as follows:

{{< carousel path="projects/git/branch/images/" >}}

To delete a branch ref, simply type:
```bash
git branch -d crazyFeature
```
{{< endrawdetails >}}











{{< rawdetails title="git log">}}
The git log command allows you to view the commit history of your repository. 
It shows details like commit hashes, authors, dates, and commit messages.

```bash
git log
```
To make the output more compact and visually appealing, you can use the following options:
1. `--oneline`: Displays each commit in a single line, making it easier to scan.
2. `--all`: Includes all branches, not just the one your HEAD is pointing to.
3. `--graph`: Displays the history in a graphical representation, showing branch relationships.
4. `--date-order`: By default the ordering of commits is topological (`--topo-order`), to have a chronologically ordered output you have to add the `--date-order` flag.
```bash
git log --oneline --all --graph --date-order
```

Example:

```bash
*   abc123 (HEAD -> master) Merge branch 'crazyFeature'
|\  
| * xyz789 Added crazy feature
| * def456 Initial commit on crazyFeature branch
* 456def Third commit
* 123abc Second commit
* 789xyz Initial commit
```
This view helps you understand the branching and merging structure at a glance.
{{< endrawdetails >}}



{{< rawdetails title="git status">}}
The git status command gives you a snapshot of your working directory. It tells you:

1. Which changes are staged for commit.
2. Which changes are not staged yet.
3. Any untracked files in your directory.

```bash
git status
```
{{< endrawdetails >}}







{{< rawdetails title="git diff">}}
The git diff command is a powerful way to view the differences between various states of your repository. It shows you what’s changed in your files, making it easier to review and understand your modifications before committing or pushing.


### Common Use Cases

1. **View Changes in Your Working Directory**:
To see changes between your working directory and the last committed state:
```bash
git diff
```

2. **Check Changes in a Specific File**:
If you want to focus on the changes in a particular file, specify its path:
```bash
git diff path/to/file  
```

3. **Compare Two Commits**:
To view the differences between two commits, provide their commit hashes:
```bash
git diff commit1-sha commit2-sha  
```

{{< endrawdetails >}}






{{< rawdetails title="git checkout - moving HEAD around">}}
In Git, the HEAD pointer determines where you are in the repository’s commit history. 
If you want to make commits, the HEAD must point to a branch or a specific commit where the changes will be applied. 
Using the git checkout (or the newer git switch) command, you can move the HEAD to the desired branch or commit.


### Moving HEAD to a Branch
When you switch to a branch using `git checkout <branch-name>`, HEAD is said to be "attached" to that branch. 
This means any new commits will be added to the branch.
```bash
git checkout crazyFeature # Move HEAD to crazyFeature branch
git checkout master # Move HEAD to master branch
```

### Detached HEAD state

If you check out a specific commit (e.g., by its hash), the HEAD enters a "detached" state. 
In this state, you can view the repository at that commit, but any changes or commits you make won’t belong to a branch.
```bash
git checkout a678ecf # Detach HEAD and view a specific commit
```
Detached HEAD can be useful for exploring past commits or testing code from a specific point in time, but be cautious: any commits made in this state may be lost unless explicitly saved (e.g., by creating a branch).


### Visual feedback 
Let's see how the following commands can be visualized:
```bash
git checkout crazyFeature # Move HEAD to crazyFeature branch
git checkout master # Move HEAD to master branch
git checkout a678ecf # Detaching HEAD
```
{{< carousel path="projects/git/checkout/images/" >}}




### Other ways to navigate history

{{< includeImage path="/projects/git/checkout/checkout.png" >}}

{{< endrawdetails >}}





{{< rawdetails title="develop branch">}}
Developing in Git revolves around working on branches. To add commits to a specific branch, you need to make sure the HEAD pointer is positioned at the tip of that branch. This ensures your changes are recorded correctly in the branch’s history.

### Switching to the Branch to Develop
To start working on a branch, you use the git checkout (or git switch) command to move the HEAD pointer to the branch you want to develop. For example:
```bash
git checkout crazyFeature # Move HEAD pointer to the crazyFeature branch
```

### Making Commits on the Branch
Once you’re on the desired branch, you can start making changes, staging them, and committing. For example:
```bash
echo "crazy feature" >> file1.txt  
git add .  
git commit -m "crazy feature"  

echo "crazy feature 2" >> file1.txt  
git add .  
git commit -m "crazy feature 2"
```
These commands add two commits to the crazyFeature branch, each capturing a new set of changes.


### Switching Back to the Main Branch
If you want to shift your focus back to the main branch (e.g., master) to make changes there, simply switch branches again:
```bash
git checkout master # Move HEAD pointer back to master
```
You can then continue committing to the master branch:

```bash

echo "third commit" >> file1.txt  
git add .  
git commit -m "third commit"
```

### Visualizing Changes
Switching branches dynamically updates your working directory to reflect the state of the branch you’re on. 
This ensures that your changes are isolated to the correct branch, keeping your work organized.
{{< carousel path="projects/git/developbranch/images/" >}}
{{< endrawdetails >}}





{{< rawdetails title="git reset - move branch reference around">}}
The git reset command allows you to move the tip of your branch to a specific commit, effectively rewriting your branch’s history. 
Since the HEAD reference points to the branch tip, it moves along with the branch when using this command.

### Moving the branch tip
To reset the branch to a specific commit, use:
```bash
git reset 7ffe2cf
```
And this is a visualization of what happens:
{{< carousel path="projects/git/reset/reset-images/" >}}

## Git reset options
The git reset command has three primary modes to control what happens to your working directory and staging area.

1. **hard**

A hard reset (`--hard`) changes the branch tip, staging area, and working directory to match the specified commit. 
All uncommitted changes are lost.
{{< carousel path="projects/git/reset/reset-hard/" >}}

**Use case**: If you made a bunch of changes to the repo (not yet staged), but wan to revert to initial state, you can do.
```bash
git reset --hard HEAD
```
Note that any untracked file will still be kept (git does not know about untracked files).

To also remove untracked files (which you can view running `git status`) you can use the `git clean` command.

Use `git clean -d` to also recurse into directorys, or `git clean -i` for an interactive mode.
In any way, `git clean` is just a "fancy" bash `rm`.

2. **mixed**

A mixed reset (`--mixed`) changes the branch tip and un-stages changes, but your working directory remains untouched.
{{< carousel path="projects/git/reset/reset-mixed/" >}}

**Use case**: If you want to split last commit into multiple commits, you can do 
```
git reset --mixed HEAD~
```
This will keep your file in the working area and now you can stage only the one you want and make more than one commit.

3. **soft**

A soft reset (`--soft`) moves the branch tip but leaves both your working directory and staging area unchanged.
{{< carousel path="projects/git/reset/reset-soft/" >}}


### Resetting individual files
If you want to revert changes in a single file rather than resetting the entire branch, you can use:
```bash
git reset -- file.txt
```
Here, `--` tells Git not to interpret subsequent arguments as commands.


### Diagram for git reset
This diagram highlights how each mode affects the branch tip, staging area, and working directory.
Using git reset effectively can help you rewrite history, clean up your work, and undo mistakes with precision.

{{< includeImage path="/projects/git/reset/diagram.png" >}}



{{< endrawdetails >}}












{{< rawdetails title="git merge">}}
The git merge command is used to combine changes from one branch into another. 
When you run git merge <branch-name>, Git incorporates the changes from the specified branch into your current branch by creating a new commit that links their histories. 
This is a fundamental part of Git’s branching and collaboration model.

### Merging Two Branches
For example, to merge the crazyFeature branch into master, you can follow these steps:

```bash
git checkout master # Ensure you are on the branch to receive the changes
git merge crazyFeature
```
Visually, this is what happens:
{{< carousel path="projects/git/merge/images/" >}}


### Handling Merge Conflicts
Sometimes, Git may encounter conflicts during the merge process if changes in the two branches overlap. 
In such cases, Git will pause the merge and mark the conflicting areas in your files.

Here’s an example of what a conflict might look like in file.txt:
```txt
first commit
second commit
<<<<<<< HEAD
third commit
=======
crazy feature
crazy feature 2
>>>>>>> crazyFeature
```
The <<<<<<< HEAD section shows the content from the current branch (master), while the ======= and >>>>>>> crazyFeature sections show the conflicting changes from the branch being merged (crazyFeature).

### Resolving the Conflict
To resolve the conflict, you can manually edit the file to decide which changes to keep, discard, or combine. For example, you might resolve the conflict like this:

```txt
first commit
second commit
third commit
crazy feature
crazy feature 2
```
After resolving the conflict, you need to stage the file and complete the merge:

```bash
git add .
git commit
```
This creates a new merge commit that records the resolution and finalizes the merge process.

{{< endrawdetails >}}





{{< rawdetails title="rebase">}}
The git rebase command is a powerful tool for streamlining your project history. 
It allows you to move commits from one branch onto another, effectively creating a cleaner and more linear sequence of commits.

When you rebase, Git reapplies commits from the current branch onto the target branch, one by one, as if they were made on top of it.

### How Rebase Works
Let’s say you have two branches: master and crazyFeature. 
If you’ve made commits on crazyFeature and want to integrate those changes into master but avoid a merge commit, you can rebase:
```bash
git checkout master  
git rebase crazyFeature
```
{{< carousel path="projects/git/rebase/images/" >}}


### Key Points to Remember
1. Use Rebase for Local Branches: Rewriting commit history with git rebase is safe only on branches that haven’t been shared with others. Avoid rebasing shared branches as it can lead to confusion.
2. Resolving Conflicts: If there are conflicts during the rebase, Git pauses the process and asks you to resolve them. Once resolved, you can continue the rebase:
```bash
git rebase --continue  
```
3. Aborting a Rebase: If something goes wrong or you change your mind, you can abort the rebase and return to the original branch state:
```bash
git rebase --abort
```
{{< endrawdetails >}}


{{< rawdetails title="rebase interactive">}}
Interactive rebasing is a more advanced version of the git rebase command, offering fine-grained control over how commits are replayed. It allows you to edit commit messages, squash commits, reorder them, or even drop them altogether. 
This is especially useful for cleaning up your branch history before sharing it with others.

### Starting an Interactive Rebase
To begin an interactive rebase, specify the number of commits to include, or a base commit to rebase onto:

```bash
git rebase -i HEAD~3
```
This opens an editor displaying the commits in reverse chronological order:
```
pick 123abc Commit message 1  
pick 456def Commit message 2  
pick 789ghi Commit message 3  
```
Each commit line starts with an action (pick) and is followed by the commit hash and message.
### Actions in Interactive Rebase
1. Reword: Edit the commit message without changing the commit itself.
2. Squash: Combine multiple commits into one.
3. Edit: Modify the content of a commit.
4. Drop: Remove a commit entirely.
5. Reorder: Change the sequence of commits.

### Reword example

```bash
git rebase -i 83dcd20
```

To edit a commit message, change pick to reword:

```
reword 2e59c3b second commit
pick b377dbe third commit
pick 2e7a67c fourth commit
```

When you save and exit, Git will prompt you to enter a new message for the specified commit.


{{< carousel path="projects/git/rebase-interactive/reword/" >}}


### Squash example

Squashing combines multiple commits into one. 
To squash a commit, replace pick with squash (or s) for the commits you want to merge:
```
pick 2e59c3b second commit
squash b377dbe third commit
squash 2e7a67c fourth commit
```
When you save, Git opens another editor to let you combine the commit messages.

{{< carousel path="projects/git/rebase-interactive/squash/" >}}

{{< endrawdetails >}}


{{< rawdetails title="stash">}}
The git stash command allows you to temporarily save changes in your working directory and staging area without committing them. 
This is especially useful when you need to switch branches or work on something else without losing your progress.

### How Git Stash Works
When you run:
```bash
git stash
```
Git saves the changes in your working directory (tracked) and staging area to a "stash stack." 
This clears your working directory, allowing you to start fresh or switch branches without interference.

To retrieve your changes later, you use:
```bash
git stash pop
```
This restores the stashed changes and removes them from the stash stack.

{{< carousel path="projects/git/stash/images/" >}}


### Additional Stash Commands
1. List Stashed Changes: View all saved stashes. To retrieve your changes later, you use:
```bash
git stash list
```

2. Apply Stash Without Deleting: Retrieve changes without removing them from the stash stack.
```bash
git stash apply
```

3. Clear Stash Stack: Remove all stashed entries.
```bash
git stash clear
```

4. Include untracked files in the stack: By default is only tracked files (the only git knows about):
```bash
git stash -u
```



{{< includeImage path="/projects/git/stash/stash.png" >}}



{{< endrawdetails >}}







# Working with Git remotely






{{< rawdetails title="commit & push">}}
When working with Git, you often need to share your changes with others or save them to a remote repository. 
This is achieved using the git commit and git push commands.

### Committing Changes Locally
The first step is to save your changes to the local repository with git commit. 
For example:
```bash
git add .  
git commit -m "second commit"
```
This records the changes in your local repository. 
At this stage, the changes are not yet shared with others or pushed to the remote repository.

### Pushing to a Remote Repository
To share your changes, you push them to a remote repository, such as origin, typically on a platform like GitHub or GitLab.
```bash
git push origin master
```
This command sends the commits from your local master branch to the master branch in the remote repository called origin.

### Visualizing the Push Process
{{< carousel path="projects/git/remotes/push/images/" >}}

When you push to origin master, Git:

1. Updates the remote branch to include your latest commits.
2. Synchronizes your local repository with the remote, ensuring your changes are visible to others who pull from the remote branch.
{{< endrawdetails >}}


{{< rawdetails title="working with branches">}}
Once you've mastered working with branches locally, it's important to understand how to push branches to a remote repository for collaboration or backup.
### Pushing a Local Branch to the Remote
To share a branch with others, you can push it to the remote repository using:
```bash
git push origin crazyFeature  
```
This command creates a new branch in the remote repository (if it doesn’t already exist) and pushes the commits from your local crazyFeature branch to the remote crazyFeature branch.

{{< carousel path="projects/git/remotes/branch/images/" >}}

### Deleting a branch
To delete a local branch reference, you can do
```bash
git push branch -d crazyFeature
```
To do the same thing but for a remote repository, you can do
```bash
git push -d origin crazyFeature
```
{{< endrawdetails >}}
















{{< rawdetails title="merging">}}
Merging combines changes from one branch into another. Once you've merged locally (as previously explained), the final step is to push the result to the remote repository so others can access the updated branch.

### Merging Locally
```bash
git checkout master
git merge crazyFeature
```
After resolving any conflicts and completing the merge locally, your local branch will contain the updated history.

### Pushing the Merge to the Remote
Once the local merge is complete, you need to push the changes to the remote branch:
```bash
git push origin master  
```
This updates the remote master branch with the result of your local merge, making it available to others.
{{< carousel path="projects/git/remotes/merge/images/" >}}
{{< endrawdetails >}}








{{< rawdetails title="what is origin/HEAD">}}
The origin/HEAD reference in Git is a symbolic pointer that indicates the default branch of the remote repository (e.g., main or master). 
It helps Git know which branch to interact with when you push or pull without explicitly specifying a branch.

### Setting origin/HEAD
By default, origin/HEAD points to the branch initially designated as the default branch in the remote repository. However, you can update this pointer using the git remote set-head command.

For example, if you want origin/HEAD to point to the crazyFeature branch, you can run:
```bash
git remote set-head origin crazyFeature  
```
This makes the workflow seamless when you push changes:
```bash
git push
```
Git automatically knows to push to origin/crazyFeature without requiring you to specify the branch explicitly.
{{< carousel path="projects/git/remotes/origin-head/images/" >}}
{{< endrawdetails >}}










{{< rawdetails title="git fetch">}}
The git fetch command allows you to retrieve updates from a remote repository without modifying your working directory. It’s a safe way to check for new commits or changes made by others before deciding how to integrate them into your local branch.
Let's see what happens when you run 
```bash
git fetch origin master
```
{{< carousel path="projects/git/remotes/fetch/images/" >}}
{{< endrawdetails >}}










{{< rawdetails title="git pull">}}
The git pull command is a convenient way to update your local branch with changes from the remote repository. 
It’s essentially a shortcut that combines two commands:
1. `git fetch`
2. `git merge origin/<branch-name>`


{{< carousel path="projects/git/remotes/pull/images/" >}}


{{< rawdetails title="git pull common mistake">}}
If you have local commits that are ahead of the remote branch and you run git pull without addressing them, Git might create a merge commit or accidentally leave you in a separate branch. 
{{< carousel path="projects/git/remotes/pull/problem/" >}}
{{< endrawdetails >}}
{{< endrawdetails >}}





{{< rawhtml >}}
</div>
{{< /rawhtml >}}



{{< rawhtml >}}
<script>


const toggleLink = document.getElementById("toggleAll");
const detailsElements = document.querySelectorAll("#collapse-all details");
let allExpanded = false; 

toggleLink.addEventListener("click", () => {
    allExpanded = !allExpanded;
    detailsElements.forEach(details => details.open = allExpanded);            
    toggleLink.textContent = allExpanded ? "▼ Close All" : "▶ Expand All";
});

</script>
    
	
{{< /rawhtml >}}

