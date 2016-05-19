guard :minitest do
  watch(%r{^(.*)\/?.rb$}) { 'test' }
end

guard :rubocop do
  watch(/.+\.rb$/)
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end
