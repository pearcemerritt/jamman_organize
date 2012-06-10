####################################################################
# File: jamman_organize.rb
# Author: Pearce Merritt
# Date: Saturday 10 June 2012
#
# This tool can be used to recurse through a JAMMAN folder
# downloaded from the DigiTech JAMMAN and organize all the poorly
# named loop files so that they resemble the folders that they
# are kept in. Specifically:
#    JAMMAN/LOOPNN/LOOP.WAV <-- JAMMAN/LOOPNN/LOOPNN.WAV
#    JAMMAN/LOOPNN/LOOP.XML <-- JAMMAN/LOOPNN/LOOPNN.XML
# The file directory structure is intact, though that may be
# a possible next direction for this project in learning ruby.
#
# Note, this is my first real ruby program! Also, my first real
# experience with the power of scripting languages on a local
# machine. I've done a bit of Perl for school and a bit of 
# JavaScript for school as well, but only for web development.
####################################################################

#! /usr/bin/env ruby

Dir.chdir("JAMMAN")

# Go through all files in the JAMMAN directory and visit all of them
# that are non-trivial directories. That is, those of the form
# LOOPNN, where NN is a number (zero padded) between 0 and 99.
Dir.foreach(".") do |jfile|

  # Ignore the trivial hidden directories and system files
  case
  when File.basename(jfile).eql?(".")
    next
  when File.basename(jfile).eql?("..")
    next
  when File.basename(jfile).eql?("SETUP.XML")
    next
  else
    puts File.basename(jfile) + ":"

    Dir.chdir(jfile) 

    # Change the name of each file in LOOPNN from LOOP.EXT to
    # LOOPNN.EXT. In this case EXT is either "WAV" or "XML".
    Dir.foreach(".") do |lfile|

      # Ignore the trivial hidden directories
      next if File.directory?(lfile)

      puts "  Changing " + lfile + " to " + jfile + File.extname(lfile)

      # LOOP.EXT <- LOOPNN.EXT
      File.rename(lfile, jfile + File.extname(lfile))

    end # LOOPNN files loop

    Dir.chdir("..")
  end # JAMMAN file case

end # JAMMAN files loop

