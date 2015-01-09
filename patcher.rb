require 'open-uri'
require 'digest/md5'
def sel
	return "======================================================\n"
end
def decrypt(x,k)
		srand(8791+k)
		result = ""
		x.each_byte{|x|
			result << (((x-rand(9999))%256).chr)
		}
		return result
end
file = File.open('patcher.cfg', 'rb')
$config_file = Marshal.load(file)
file.close
$path_file = decrypt($config_file[1],$config_file[0])
$main_dir = decrypt($config_file[2],$config_file[0])
module Zeiling
		module Patch
				def self.uri_download(x,y)
					open(x.gsub("\x20","_")){|f|File.open(y,'wb'){|w|w.write(f.read)}}
				end
				def self.calculate_md5(x)
					return Digest::MD5.hexdigest(lambda{File.open(x,'rb'){|f|return f.read}}.call)
				end
				def self.patch
						print sel
						print "Downloading patch file...\n"
						print sel
						Zeiling::Patch.uri_download($path_file, 'patch.zl')
						file = File.open('patch.zl', 'rb')
						$loc_table = Marshal.load(file)
						file.close 
						print sel
						print "Updating files...\n"
						print sel
						$loc_table.each{|x|
							md5 = Zeiling::Patch.calculate_md5(x[0])
							unless md5 == x[1]
									print "Downloading #{x[0]}...\n"
									Zeiling::Patch.uri_download("#{$main_dir}#{x[0]}", x[0])
							else
									print "#{x[0]} was latest.\n"
							end
						}
						print sel
						print "Patch complete.\n"
						print sel
				end
		end
end
begin
	print sel
	print "**Narzew Autopatcher\n"
	print "**by Narzew\n"
	print "**v 1.0\n"
	print sel
	Zeiling::Patch.patch
	$stdin.gets
rescue => e
	print sel
	print "Error : #{e}\n"
	print sel
	$stdin.gets
	exit
end
