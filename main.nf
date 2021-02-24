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

def final_output_file = 'All.txt'
italian = Channel.from 'Ciao'
french = Channel.from 'Bonjour'
english = Channel.from 'Hello'
spanish = Channel.from 'Hola'
start = Channel.fromPath 'Welcome.txt'

if (new File(final_output_file).exists())
  new File(final_output_file).delete()

process sayHelloInItalian {
  input:
  val (x) from italian
  path (previous_file) from start
  val (output) from 'italian.txt'

  output:
  path('italian.txt') into italian_ch

  shell:
  template 'hello.sh'
}

process sayHelloInFrench {
  input:
  val (x) from french
  path (previous_file) from italian_ch
  val (output) from 'french.txt'

  output:
  path('french.txt') into french_ch

  shell:
  template 'hello.sh'
}


process sayHelloInSpanish {
  input:
  val (x) from spanish
  path (previous_file) from french_ch
  val (output) from 'spanish.txt'


  output:
  path('spanish.txt') into spanish_ch

  shell:
  template 'hello.sh'
}

process sayHelloInEnglish {
  input:
  val (x) from english
  path (previous_file) from spanish_ch
  val (output) from 'english.txt'


  output:
  path('english.txt') into english_ch

  shell:
  template 'hello.sh'
}

english_ch.subscribe { file ->
  Files.copy(Paths.get(file.toString()), Paths.get(final_output_file))
}

workflow.onComplete {
  log.info "Nextflow says:"
  log.info new File(final_output_file).text
}