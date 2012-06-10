#! /usr/bin/env ruby

#jamman_dir = Dir.open("JAMMAN")
Dir.chdir("JAMMAN")

i = 1
#jamman_dir.each do |jfile|
Dir.foreach(".") do |jfile|
  ##puts "File: JAMMAN/#{jfile}"
  #puts "File: " + File.expand_path(jfile)
  ##puts "Is directory: " + File.directory?(File.expand_path(jfile)).to_s
  #puts "Is directory: " + File.directory?(jfile).to_s
  case
  when File.basename(jfile).eql?(".")
    next
  when File.basename(jfile).eql?("..")
    next
  when File.basename(jfile).eql?("SETUP.XML")
    next
  else
    puts "Directory: " + File.expand_path(jfile)

    #loop_dir = Dir.open(File.basename(jfile))
    Dir.chdir(jfile) 

    #loop_dir.each do |lfile|
    Dir.foreach(".") do |lfile|

      case
      when File.basename(lfile).eql?(".")
        next
      when File.basename(lfile).eql?("..")
        next
      else
        puts "  Will change " + lfile + " to " + jfile + File.extname(lfile)

        File.rename(lfile, jfile + File.extname(lfile))
        #if i < 10
          ##loop_dir = Dir.open("LOOP0" + i.to_s)
          #puts "  LOOP0" + i.to_s
        #else
          #puts "  LOOP" + i.to_s
        #end

        #++i
      end # LOOPNN files case
    end # LOOPNN files loop

    Dir.chdir("..")

  end # JAMMAN file case
end # JAMMAN files loop

