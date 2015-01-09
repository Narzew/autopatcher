require 'digest/md5'
def encrypt(x,k)
		srand(8791+k)
		result = ""
		x.each_byte{|x|
			result << (((x+rand(9999))%256).chr)
		}
		return result
end
module Zeiling
		module Patch
				def self.patch_table(locations_ary)
					result = []
					locations_ary.each{|location|
						Dir.foreach(location){|x|
							if x != '.'
								if x != '..'
									loc_p = "#{location}/#{x}"
									file = File.open(loc_p, 'rb')
									data = Digest::MD5.hexdigest(file.read)
									file.close
									result << [loc_p,data]
									print "#{loc_p} done.\n"
								end
							end
						}
					}
					return result
				end
				def self.make_patch
					$loc_table = Zeiling::Patch.patch_table($locations)
					file = File.open('System/patch.zl', 'wb')
					Marshal.dump($loc_table, file)
					file.close
				end
		end		
end
begin
	file = File.open('config.ini', 'rb')
	data = file.read
	eval(data)
	file.close
	$key = rand(99999999)
	$config_file = [$key, encrypt($path_file,$key), encrypt($main_dir,$key)]
	file = File.open('patcher.cfg', 'wb')
	Marshal.dump($config_file, file)
	file.close
	Zeiling::Patch.make_patch
	print "Patch created succesfully.\n"
	$stdin.gets
rescue => e
	print "Error : #{e}\n"
	$stdin.gets
	exit
end