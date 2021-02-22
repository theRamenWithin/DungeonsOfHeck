Gem::Specification.new do |s|
    s.name        = 'dungeonsofheck'
    s.version     = '1.2'
    s.license     = 'MIT'
    s.date        = '2020-10-02'
    s.summary     = "Dungeons of Heck"
    s.description = "A gem for playing the game Dungeons of Heck"
    s.authors     = ["Alex Berenger Pike"]
    s.email       = 'alex.pike.ap@outlook.com'
    s.homepage    = 'https://github.com/theRamenWithin/DungeonsOfHeck'
    
    s.files       = Dir['lib/*.rb', 'lib/*.txt','Gemfile', 'spec/*.rb']
    s.files.reject! { |fn| fn.include? "CVS" }

    s.add_runtime_dependency "tty-box", "~> 0.6.0"
    s.add_runtime_dependency "tty-prompt", "~> 0.22.0"
    s.add_runtime_dependency "tty-font", "~> 0.5.0"
    s.add_runtime_dependency "tty-table", "~> 0.12.0"   
    s.add_runtime_dependency "colorize", "~> 0.8.1"
    s.add_runtime_dependency "rspec", "~> 3.9"
end
