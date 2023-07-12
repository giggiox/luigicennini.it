---
title: "fork telemetry"
date: 2023-04-03T19:53:33+05:30
draft: false
author: "Luigi"
tags:
  - Rich content
  - Sample
  - example
image: /projects/forktelemetry/copertina.jpg
description: ""
toc: true
mathjax: true
---




# Introduzione

L'obiettivo di questo progetto è quello di sviluppare un'alternativa più economica ai sistemi di telemetria disponibili sul mercato per le mountain bike e le moto da cross.

I sistemi di telemetria per le mountain bike consentono di monitorare e acquisire dati sulla posizione della forcella e dell'ammortizzatore della bici durante la guida. Questi dati sono fondamentali per gli appassionati di sport off-road e gli atleti professionisti, in quanto forniscono informazioni preziose per analizzare e migliorare le prestazioni.

Attualmente, molti sistemi di telemetria, come ad esempio [byb telemetry](https://www.bybtech.it/), utilizzano costosi potenziometri lineari per misurare con precisione la posizione della forcella e dell'ammortizzatore.

Altri utenti su internet hanno provato altri modi per ottenere un buon risultato, per esempio un [sensore LiDar](https://www.vitalmtb.com/forums/The-Hub,2/DIY-mtb-telemetry-data,11126), con dei risultati però non troppo incoraggianti in quanto troppo rumorosi.

Dunque, dopo un'attenta valutazione, ho concluso che l'utilizzo di un encoder rotativo rappresenta un'alternativa più vantaggiosa dal punto di vista economico.

La ragione principale di questa scelta è che gli encoder rotativi sono meno costosi rispetto ai potenziometri lineari e offrono comunque una buona precisione nella misurazione della posizione. Inoltre, gli encoder rotativi sono generalmente più robusti e meno soggetti a danni rispetto agli encoder lineari, che possono essere più fragili e suscettibili a guasti in ambienti off-road.


# pre - prototipazione

Prima di procedere con la prototipazione del sensore della forcella, ho eseguito un'analisi di fattibilità per valutare la possibilità di realizzare questo progetto.

Come punto di partenza, ho selezionato un encoder rotativo affidabile: l'LPD3806. Questo tipo di encoder offre una risoluzione di 600 PPR (pulses per revolution). Utilizzando una puleggia con un diametro di 9,4 mm, si ottiene una densità di circa 30 rilevazioni per millimetro di movimento della forcella. Questo perché l'encoder genera un segnale di quadratura che può essere letto sia sul fronte di salita che su quello di discesa. Sfruttando entrambi i fronti, otteniamo una risoluzione quadruplicata dell'encoder, ovvero 24000 PPR (600 PPR * 4).

Calcolando il numero di osservazioni possibili per ogni millimetro di movimento della forcella, otteniamo il seguente risultato:

$$ \frac{600 * 4}{\pi* 9.4} \approx 30 $$


Ad esempio, considerando una forcella di 150 mm di escursione, si avranno circa 12190 rilevazioni (questo valore sarà utilizzato nel codice).

È importante notare che aumentando il diametro della puleggia accoppiata all'encoder, si riduce la densità di rilevazioni per millimetro di movimento. Inoltre, bisogna considerare la velocità massima di risposta dell'encoder, la quale determina la velocità lineare massima che la forcella può raggiungere. Nel caso dell'LPD3806, la velocità massima è di:


​$$ 2000 RPM = 2000/60 RPS = 2000* (\pi*9.4) /60 \frac{mm}{s} \approx 983 \frac{mm}{s} $$
 

Se si utilizza una puleggia con un diametro ridotto, si otterrà una velocità lineare massima superiore per la forcella.

Con queste informazioni iniziali, ho dunque iniziato il processo di prototipazione.




# prototipazione

Per la prototipazione del sensore della forcella, ho utilizzato il software [fusion 360](https://www.autodesk.it/products/fusion-360/overview). Dopo diverse iterazioni, sono giunto al seguente risultato:

{{< rawhtml >}} 
<center>
<img src="/projects/forktelemetry/forkSensor.jpg"  width="80%" >
</center>
{{< /rawhtml >}}

Per il design, mi sono ispirato al movimento degli assi di una stampante 3D e ho integrato un meccanismo di tensionamento della cinghia, tipico di questo tipo di stampanti.


Successivamente, ho utilizzato Arduino Nano per realizzare un Proof of Concept (POC) funzionante. Nel complesso, il sistema è composto da 2 switch, 1 modulo SD, 1 Arduino Nano, 1 batteria da 9 volt e l'encoder LPD3806.
Dove:
- uno switch serve per accendere il sistema
- l'altro switch abilita la scrittura della posizione dell'encoder con la codifica scelta ( \[posizione_encoder,]) nella scheda SD. Questo switch dovrà essere attiviato prima dell'inizio della discesa e spento subito dopo.


{{< rawhtml >}} 
<center>
<img src="/projects/forktelemetry/forktelemetry-schematics.png"  width="60%" >
</center>
{{< /rawhtml >}}


A questo punto, ho progettato anche una scatola di acquisizione utilizzando Fusion 360.
{{< rawhtml >}} 
<center>
<img src="/projects/forktelemetry/box_fusion.PNG"  width="80%" >
</center>
{{< /rawhtml >}}
La scatola, che è disegnata in modo da essere fissata con 2 fascette al tubo superiore della bici, contiene tutti i componenti (tranne l'encoder) e rende accessibile dall'esterno i 2 switch.
{{< rawhtml >}} 
<center>
<img src="/projects/forktelemetry/openbox_fusion.PNG"  width="80%" >
</center>
{{< /rawhtml >}}







# stampa e codice


Una volta stampato (e assemblato) il sensore e la scatola di acquisizione saldando i componenti su una millefori

{{< rawhtml >}} 
<center>
<img src="/projects/forktelemetry/collage.png"  width="80%" >
</center>
{{< /rawhtml >}}



il tutto si presenta in questo modo:

{{< rawhtml >}} 
<center>
<img src="/projects/forktelemetry/laydown.jpg"  width="80%" >
</center>
{{< /rawhtml >}}



Il funzionamento una volta montati sulla MTB è il seguente:

{{< rawhtml >}} 
<center>
<video width=30% controls>
    <source src="/projects/forktelemetry/video.mp4" type="video/mp4" >
    Your browser does not support the video tag.  
</video>
</center>
{{< /rawhtml >}}



Il codice invece è il seguente.
Notare che per avere una massima velocità in lettura dell'encoder si è utilizzata la tecnica della manipolazione delle porte.



```cpp
#include <SPI.h>
#include <SD.h>
#include <String.h>

#define encoderPinA 3
#define encoderPinB 2
#define buttonPin 7
#define SD_PIN 10

File logFile;
bool enableWriteToSD=false;

int newDirectoryName=0;
int newFileName=0;

bool startRecord;
volatile long encoderPosition=0;
volatile bool aStatePrev,bStatePrev,aState,bState;


void setup() {
  Serial.begin(9600);

  //setup rotary encoder
  DDRD &= ~((1 << encoderPinA) | (1 << encoderPinB));
  // Abilita i pull-up interni
  PORTD |= (1 << encoderPinA) | (1 << encoderPinB);
  attachInterrupt(digitalPinToInterrupt(encoderPinA),handleEncoderInterrupt,CHANGE);
  attachInterrupt(digitalPinToInterrupt(encoderPinB),handleEncoderInterrupt,CHANGE);

  //setup SD
  if(!SD.begin(SD_PIN)){ while(true); }

  while(SD.exists(String(newDirectoryName))){ newDirectoryName++; }
  if (SD.mkdir(String(newDirectoryName))){
    Serial.print("Created new directory: ");
    Serial.println(newDirectoryName);
  }


  //setup record button
  DDRD &= ~(1 << buttonPin);
  PORTD |= (1 << buttonPin);
  
  Serial.println("setup completed");
}

void loop() {
  startRecord=PIND&(1<<buttonPin);
  if(startRecord && !enableWriteToSD){
    logFile = SD.open(String(newDirectoryName) + "/" +  String(newFileName++) +".txt", FILE_WRITE);
    if (logFile) { Serial.println("Writing to "+ String(newFileName-1)); }
    enableWriteToSD=true;
  }
  else if(startRecord && enableWriteToSD) {
     logFile.print(String(encoderPosition)+",");
  }
  else if(!startRecord && enableWriteToSD){
    enableWriteToSD=false;
    logFile.close();
  }
}


void handleEncoderInterrupt(){
  // Leggi lo stato corrente dei segnali A e B
  aState = PIND & (1 << encoderPinA);
  bState = PIND & (1 << encoderPinB);

  // Verifica se il fronte di salita è avvenuto sul segnale A
  if (aState != aStatePrev) {
    aStatePrev = aState;
    // Verifica il cambiamento di direzione dell'encoder
    if (aStatePrev == bStatePrev) {
      encoderPosition--;
    } else {
      encoderPosition++;
    }
  }
  // Memorizza lo stato corrente dei segnali A e B per il prossimo interrupt
  bStatePrev = bState;
}
```


# primi test e risultati
Dopo aver attivato  lo switch per avviare la registrazione il codice crea un file di log all'interno della sua cartella che non è altro che il valore della posizione dell'encoder separato da virgole.

Ho scritto un sito web in javascript utilizzando la libreria [Plotly JS](https://plotly.com/javascript/) che serve per visualizzare questi dati ([Link GitHub al codice del sito](https://github.com/giggiox/fork-telemetry/tree/main/web)). 
Quindi per esempio il video precedente produce un file di log che è poi possibile aprire nel sito e genera questo output:
{{< rawhtml >}} 
<center>
<img src="/projects/forktelemetry/plot.png"  width="80%" >
</center>
{{< /rawhtml >}}

Inoltre vengono mostrati il numero di bottom out avuti (in questo caso zero), il valore più usato durante una registrazione e la percentuale di forca usata (in questo esempio più di 26 mm di una forca di 150mm quindi circa il 18%).

Ho anche scritto uno script python ([Link GitHub allo script](https://github.com/giggiox/fork-telemetry/blob/main/videoEdit.ipynb)) che utilizza [Pillow](https://pypi.org/project/Pillow/) e [cv2](https://pypi.org/project/opencv-python/).
Questo script serve per aggiungere la telemetria rilevata a un video, con risultato una cosa così:
{{< rawhtml >}} 
<center>
<video width=30% controls>
    <source src="/images/projects/forktelemetry/videoTelemetry.mp4" type="video/mp4" >
    Your browser does not support the video tag.  
</video>
</center>
{{< /rawhtml >}}


Quello che fa è innanzitutto generare 101 immagini del rettangolo con dentro la percentuale (da 0% a 100%). Poi unisce queste immagini creando un video dove ogni immagine corrisponde a un dato rilevato dal sensore.


# test sul campo
Provando a fare i primi test sul campo ovvero provando il sistema su una vera discesa da enduro sono sorti i primi problemi  e limitazioni dell'hardware usato (dell'arduino, in particolare).
Infatti per impatti troppo veloci, il conto degli impulsi ricevuti dall'encoder inizia a "driftare" e diventare sempre più negativo.

{{< rawhtml >}} 
<center>
<img src="/projects/forktelemetry/testSulCampo.PNG"  width="80%" >
</center>
{{< /rawhtml >}}

Questo perchè la risposta dell'encoder ha una frequenza tra 0-20KHz. Questo significa che tra un fronte di salita e un altro c'è un tempo di almeno 50 microsecondi.
Anche ammettendo di leggere solo i fronti di salita del segnale A (dunque riducendo la stima della precisione fatta in precedenza di 1/4) l'arduino non è in grado di svolgere in questo poco tempo tutte le operazioni richieste.
Infatti dovrebbe
- fare una `digitalRead()` sul pin del segnale B
- scrivere sull'SD la posizione

Nelle 2 prossime provo ad analizzare il codice e capire perchè l'arduino non è il modo corretto di procedere. 

## digitalRead

Per esempio guardiamo quanto tempo prende una digitalRead() usando la manipolazione delle porte.
Possiamo per esempio prendere questo codice arduino che fa una digitalRead() dell'encoderPinB e se risulta HIGH allora aggiunge 1 all'encoderPosition, altrimenti diminusice di 1 la variabile.

```cpp
void handleEncoderInterrupt(){
  // Leggi lo stato corrente del segnale B
  PIND & (1 << encoderPinB) ? encoderPosition +=1 : encoderPosition -=1;
}
```

e decompilarlo `C:\Users\luigi\AppData\Local\Temp\arduino_build_211859>"C:\Program Files (x86)\Arduino\hardware\tools\avr\bin\avr-objdump.exe" -S codice_test.ino.elf`

ottenendo 
```asm
a8:   4a 9b           sbis    0x09, 2 ; 9
aa:   0c c0           rjmp    .+24            ; 0xc4 <_Z22handleEncoderInterruptv+0x1c>
ac:   80 91 04 01     lds     r24, 0x0104     ; 0x800104 <__data_end>
b0:   90 91 05 01     lds     r25, 0x0105     ; 0x800105 <__data_end+0x1>
b4:   a0 91 06 01x     lds     r26, 0x0106     ; 0x800106 <__data_end+0x2>
b8:   b0 91 07 01     lds     r27, 0x0107     ; 0x800107 <__data_end+0x3>
bc:   01 96           adiw    r24, 0x01       ; 1
be:   a1 1d           adc     r26, r1
c0:   b1 1d           adc     r27, r1
c2:   0b c0           rjmp    .+22            ; 0xda <_Z22handleEncoderInterruptv+0x32>
c4:   80 91 04 01     lds     r24, 0x0104     ; 0x800104 <__data_end>
c8:   90 91 05 01     lds     r25, 0x0105     ; 0x800105 <__data_end+0x1>
cc:   a0 91 06 01     lds     r26, 0x0106     ; 0x800106 <__data_end+0x2>
d0:   b0 91 07 01     lds     r27, 0x0107     ; 0x800107 <__data_end+0x3>
d4:   01 97           sbiw    r24, 0x01       ; 1
d6:   a1 09           sbc     r26, r1
d8:   b1 09           sbc     r27, r1
da:   80 93 04 01     sts     0x0104, r24     ; 0x800104 <__data_end>
de:   90 93 05 01     sts     0x0105, r25     ; 0x800105 <__data_end+0x1>
e2:   a0 93 06 01     sts     0x0106, r26     ; 0x800106 <__data_end+0x2>
e6:   b0 93 07 01     sts     0x0107, r27     ; 0x800107 <__data_end+0x3>
ea:   08 95           ret
```

In particolare le istruzioni che fanno la lettura digitale dell'encoderPinB sono dalla 2a alla 6a, ovvero le 4 istruzioni che utilizzano `lds` (Load direct from SRAM).
Dal [datasheet dell'ATmega328 (pagina 283)](https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-7810-Automotive-Microcontrollers-ATmega328P_Datasheet.pdf) possiamo vedere che queste istruzioni prendono esattamente 2 cicli di clock.


{{< rawhtml >}} 
<center>
<img src="/images/projects/forktelemetry/datasheet.PNG"  width="80%" >
</center>
{{< /rawhtml >}}

Dunque essendo un microcontrollore a 16Mhz (1 ciclo di clock richiede 1/16.000.000 di secondo, cioè 62,5 nanosecondi), allora quelle 4 istruzioni richiedono 8 cicli  * 62,5 ns/ciclo = 500 ns.

Da questa analisi è possibile dedurre che la digitalRead() non è il collo di bottiglia nel codice.


## scrittura SD

Guardiamo invece quanto tempo impiega una scrittura sull'SD, per avere un numero più o meno approssimativo possiamo per esempio stampare il numero di millisecondi prima e dopo l'esecuzione della scritura della posizione nella memoria.

```cpp
Serial.println(millis());
logFile.print(String(encoderPosition)+",");
Serial.println(millis());
```

E possiamo vedere che effettivamente il collo di bottiglia è  proprio in questa chiamata che può arrivare a prendere anche 200 millisecondi. 





# sviluppi futuri

In futuro 

- usare un microcontrollore con più core, per esempio un esp32 dove un core viene dedicato alla lettura del segnale dell'encoder e un altro alla campionatura (che a questo punto è possibile fare in maniera costante per esempio 1000 volte al secondo) e scrittura sull'SD della posizione dell'encoder.
- utilizzare un modulo bluetooth per comunicare i dati a un' applicazione android, anche in real time.
- aggiungere un modulo GPS in modo da poter avere nel pannello di analisi non solo la posizione della forca metro per metro ma anche la posizione del rider lungo la discesa.
- redesign del sensore. Il primo design fatto è stato fatto top-down (anche perchè era la prima volta che utilizzavo fusion360 e anche la prima che disegnavo davvero qualcosa di funzionale) e con forme a scatola (non strutturalmente solide) e può essere di gran lunga migliorato. Per esempio utilizzando una guida lineare è possibile ridurre la complessità del sensore (insieme al peso) ma anche i gradi di libertà del sistema.  Qui sotto il design di una possibile v2 del progetto utilizzando una guida lineare di 6mm.

{{< rawhtml >}} 
<center>
<img src="/projects/forktelemetry/rev2.PNG"  width="80%" >
</center>
{{< /rawhtml >}}








