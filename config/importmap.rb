# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'

pin 'buffer', to: 'https://cdn.skypack.dev/buffer', preload: true
pin '@hashgraph/cryptography', to: 'https://cdn.skypack.dev/@hashgraph/cryptography', preload: true
pin '@hashgraph/sdk', to: 'https://cdn.skypack.dev/@hashgraph/sdk'
pin 'hashconnect', to: 'https://cdn.skypack.dev/hashconnect'
