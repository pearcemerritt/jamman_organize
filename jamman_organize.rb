#! /usr/bin/env ruby

Dir.chdir("JAMMAN")

# Go through all files in the JAMMAN directory and visit all of them
# that are non-trivial directories. That is, those of the form
# LOOPNN, where NN is a number (zero padded) between 0 and 99.
Dir.foreach(".") do |jfile|

  case
  when File.basename(jfile).eql?(".")
    next
  when File.basename(jfile).eql?("..")
    next
  when File.basename(jfile).eql?("SETUP.XML")
    next
  else
    #puts "Directory: " + File.expand_path(jfile)
    puts File.basename(jfile) + ":"

    Dir.chdir(jfile) 

    # Change the name of each file in LOOPNN from LOOP.EXT to
    # LOOPNN.EXT. In this case EXT is either "WAV" or "XML".
    Dir.foreach(".") do |lfile|

      # Ignore the trivial hidden directories
      next if File.directory?(lfile)

      #case
      #when File.basename(lfile).eql?(".")
        #next
      #when File.basename(lfile).eql?("..")
        #next
      #else

      puts "  Changing " + lfile + " to " + jfile + File.extname(lfile)

      # LOOP.EXT <- LOOPNN.EXT
      File.rename(lfile, jfile + File.extname(lfile))

      #end # LOOPNN files case

    end # LOOPNN files loop

    Dir.chdir("..")
  end # JAMMAN file case

end # JAMMAN files loop

