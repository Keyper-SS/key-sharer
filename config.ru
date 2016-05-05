Dir.glob('./{config,lib,models,services,controllers}/init.rb').each do |file|
  require file
end
run ShareKeysAPI
