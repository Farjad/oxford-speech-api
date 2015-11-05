# oxford-speech-api
Ruby gem for Microsoft Oxford Speech api

### Usage
```ruby
require 'oxford-speech-api'
api = OxfordSpeechApi.new("clientId", "secret")
api.speech2text("file.wav", "audio/wav", "8000") // returns json
api.text2speech("hello world") // return wav
```
