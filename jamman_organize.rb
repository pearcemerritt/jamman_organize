#! /usr/bin/env ruby

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

require 'optparse'
require 'FileUtils'

#---Option Handling-------------------------------------------------

# Store options from command line if present.
options = {}

# Set the default directory to organize: "JAMMAN"
options[:directory] = "JAMMAN"

# Extract destructively the options from the command line and
# process them using individual cases.
OptionParser.new do |opts|

  # This is called with the "-h --help" option.
  opts.banner = "Usage: jamman_organize.rb [-vhf]"

  # Note that on this option the hash value is not a boolean
  # but a string of the directory name specified as the argument
  # to the "-d" option.
  opts.on("-d", "--directory DIR", 
          "Specify directory DIR (default is \"JAMMAN\")") do |d|
    options[:directory] = d
  end # directory option definition

  opts.on("-v", "--[no-]verbose", "Output more information") do |v|
    options[:verbose] = v
  end # verbose option definition

  opts.on("-h", "--help", "Display this list of options") do
    puts opts
    exit
  end # help option definition

# Parse will not only read the options from the command line,
# but it will also delete them from ARGV leaving only a list
# of files. This destructive nature is the reason for the
# exclamation point.
end.parse! # OptionParser instantiation

#---Option Handling End---------------------------------------------


#---Organizing------------------------------------------------------

# First copy the whole directory and save a copy with the same
# name plus a "_cp" appended to the end.
FileUtils.cp_r options[:directory], options[:directory] + "_cp"

# This changes to the "JAMMAN" directory unless the user has 
# specified another directory via the "-d" option.
Dir.chdir(options[:directory])

# Go through all files in the specified directory and visit all of 
# them that are non-trivial directories. That is, those of the form
# LOOPNN, where NN is a number (zero padded) between 0 and 99.
Dir.foreach(".") do |dfile|

  # Ignore the trivial hidden directories and system files
  case
  when File.basename(dfile).eql?(".")
    next
  when File.basename(dfile).eql?("..")
    next
  when File.basename(dfile).eql?("SETUP.XML")
    next
  when File.basename(dfile).eql?(".DS_Store")
    next
  else
    # Verbose output
    puts File.basename(dfile) + ":" if options[:verbose]

    Dir.chdir(dfile) 

    # Change the name of each file in LOOPNN from LOOP.EXT to
    # LOOPNN.EXT and extract it into the super directory. 
    # In this case EXT is either "WAV" or "XML".
    Dir.foreach(".") do |lfile|

      # Ignore the trivial hidden directories
      next if File.directory?(lfile)

      # If the verbose option has been specified at the command
      # line, then let the user know exactly which file names are
      # being altered and how.
      if options[:verbose]
        puts "  Changing " + lfile + " to " + 
             "../" + dfile + File.extname(lfile)
      end # verbose output if

      # PseudoCode: LOOPNN.EXT <- ../LOOPNN.EXT
      # Essentially, this takes care of renaming and extracting
      # the contents of LOOPNN in one step.
      FileUtils.mv(lfile, "../" + dfile + File.extname(lfile))

    end # LOOPNN files loop

    Dir.chdir("..")

    # Verbose output
    puts "  Removing " + dfile if options[:verbose]

    # Remove the LOOPNN directory that we were just in, as the
    # files have been extracted making it empty and useless.
    FileUtils.rm_r(dfile)

  end # directory file case

end # directory files loop

#---Organizing End--------------------------------------------------

