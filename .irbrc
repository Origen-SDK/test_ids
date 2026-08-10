# frozen_string_literal: true

$VERBOSE = nil
require 'rubygems'
require 'irb/completion'
require 'irb/ext/save-history'

IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:IRB_NAME] = 'origen'
