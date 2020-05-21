#!/usr/bin/env nextflow

/*
========================================================================================
                         Hello Nextflow Pipeline
========================================================================================
 manuelesimi/hello-nextflow

 @Homepage / Documentation
 https://github.com/manuelesimi/hello-nextflow
----------------------------------------------------------------------------------------
*/

import java.nio.file.Files
import java.nio.file.Paths

def input_filename = 'welcome.txt'
def output_filename = 'all.txt'

if (new File(output_filename).exists())
  new File(output_filename).delete()

def welcomeFile = new File(input_filename)
if (welcomeFile.exists())
  welcomeFile.delete()
welcomeFile.write('--- Welcome ---\n')

input_ch = Channel.fromPath(input_filename)

process sayHelloInItalian {
  input: 
    val (x) from 'Ciao'
    path (previous_file) from input_ch
    val (output) from 'italian.txt'

  output:
    path('italian.txt') into italian_ch

  shell:
    template 'hello.sh'
}

process sayHelloInFrench {

  input:
    val (x) from 'Bonjour'
    path (previous_file) from italian_ch
    val (output) from 'french.txt'

  output:
    path('french.txt') into french_ch

  shell:
    template 'hello.sh'
}


process sayHelloInSpanish {

  input:
    val (x) from 'Hola'
    path (previous_file) from french_ch
    val (output) from 'spanish.txt'


  output:
    path('spanish.txt') into spanish_ch

  shell:
    template 'hello.sh'
}

process sayHelloInEnglish {

  input:
    val (x) from 'Hello'
    path (previous_file) from spanish_ch
    val (output) from 'english.txt'

  output:
    path('english.txt') into english_ch

  shell:
    template 'hello.sh'
}

english_ch.subscribe { file ->
  Files.copy(Paths.get(file.toString()), Paths.get(output_filename))
}

workflow.onComplete {
  log.info "Nextflow says:"
  log.info new File(output_filename).text
}

workflow.onError {
  log.error "Something went wrong: ${workflow.errorMessage}"
  log.error "${workflow.errorReport}"
}