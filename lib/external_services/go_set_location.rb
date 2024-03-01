require 'ffi'

module GoSetLocation
  extend FFI::Library
  ffi_lib Rails.root.join('go_tasks', 'gosdk', 'libsetlocation.so') # Update with the actual path
  attach_function :setLocation, %i[long string string long long string string], :string
end
