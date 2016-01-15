include SwapDevice

action :create do
  device = @new_resource.name
  partition = device + '1'
  size = @new_resource.size
  persist = @new_resource.persist

  package 'parted'

  bash 'create_swap_partition' do
    code <<-EOH
      parted -s #{device} mklabel msdos
      parted #{device} mkpart primary linux-swap 512 #{size}
      EOH
    only_if "lsblk #{device}"
    not_if "lsblk #{partition}" 
  end

  bash 'enable_swap' do
    code <<-EOH
      mkswap #{partition}
      swapon #{partition}
      EOH
    only_if "lsblk #{partition}"
    not_if { swap_enabled?(partition) }
  end    

  ruby_block 'persist' do
    block do
      line = "#{partition} swap swap defaults 0 0"
      file = Chef::Util::FileEdit.new("/etc/fstab")
      file.insert_line_if_no_match(/#{line}/, line)
      file.write_file
    end
    only_if "lsblk #{partition}"
    only_if { persist }
  end

end
