
# List of all actions supported by the provider
actions :create, :remove

# Make create the default action
default_action :create

# Require attributes
attribute :device,    kind_of: String, name_attribute: true
attribute :size,    kind_of: String, default: '100%'
attribute :persist, kind_of: [TrueClass, FalseClass], default: true
