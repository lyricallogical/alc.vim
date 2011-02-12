#!/bin/zsh

ruby ../alc.rb "ruby" -n3      >|e_ruby-n3.actual        && diff e_ruby-n3.expected        e_ruby-n3.actual
ruby ../alc.rb -n3 "ruby"      >|e_ruby-n3.actual        && diff e_ruby-n3.expected        e_ruby-n3.actual
ruby ../alc.rb "cheese grater" >|e_cheese-grater.actual  && diff e_cheese-grater.expected  e_cheese-grater.actual
ruby ../alc.rb "frog"          >|e_frog.actual           && diff e_frog.expected           e_frog.actual
ruby ../alc.rb "蛙" -n12       >|j_frog.actual           && diff j_frog.expected           j_frog.actual
ruby ../alc.rb "井の中の蛙"    >|j_frog-in-a-well.actual && diff j_frog-in-a-well.expected j_frog-in-a-well.actual

