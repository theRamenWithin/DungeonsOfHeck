Gem::Specification.new do |s|
    s.name        = 'dungeonsofheck'
    s.version     = '1.0'
    s.license     = 'MIT'
    s.date        = '2020-10-02'
    s.summary     = "Dungeons of Heck"
    s.description = "A gem for playing the game Dungeons of Heck"
    s.authors     = ["Alex Berenger Pike"]
    s.email       = 'alex.pike.ap@outlook.com'
    s.files       = Dir['lib/*.*']
    s.files      += Dir['[A-Z]*'] + Dir['spec/*']
    s.files.reject! { |fn| fn.include? "CVS" }
    s.homepage    = 'https://github.com/theRamenWithin/Assignments/tree/master/Term1/Assignment3'
end