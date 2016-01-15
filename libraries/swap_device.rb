module SwapDevice
  def swap_enabled?(path)
    enabled_swapfiles = shell_out('swapon --summary').stdout
    # Regex for our resource path and only our resource path
    # It will terminate on whitespace after the path it match
    # /testswapfile would match
    # /testswapfiledir/someotherfile will not
    swapfile_regex = Regexp.new("^#{path}[\\s\\t\\n\\f]+")
    !swapfile_regex.match(enabled_swapfiles).nil?
  end
end
