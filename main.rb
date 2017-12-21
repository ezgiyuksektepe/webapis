require_relative 'MusicIdentifier'

if ARGV.length != 1
  raise 'Need an mp3 file as an argument'
end

MusicIdentifier.identify(ARGV[0])
