guard 'rake', :task => 'dist' do
  watch(%r{^src/.+})
end

guard :shell do
  watch /README\.md/ do |m|
    `rake readme`
  end
end