# Copyright 2012 Team 254. All Rights Reserved.
# @author pat@patfairbank.com (Patrick Fairbank)
#
# Script for starting/stopping the parts management server.

require "bundler/setup"
require "daemons"
require "pathological"
require "thin"

require "parts_server"
Thin::Server.start("0.0.0.0", CheesyCommon::Config.port, CheesyParts::Server)
