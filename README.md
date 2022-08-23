# gildedrose

Ensure that you have rspec and ruby_deep_clone installed, otherwise run bundle install and install packages via the gemfile

Refactorisation of the code was performed by creating a set of tests prior to code alteration. There are two spec files, one which matches the behvaiour to those determined by the author of the of this repository. The other which compares the behaviours of the original code and the refactored code, this one is performed programatically and probabilistically and minimised the edge cases not detected by the author.

The refactorisation, followed a general rule of thumbs of avoiding nested conditionals, separating the procedures performed in the update_quality method into several methods, a balance had to be made between minimising the amount of repeated code and ensuring the code was readable and easy to maintain and modify with a general preference towards the latter.

