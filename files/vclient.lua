--[[
/usr/lib/lua/luci/controller/admin/vclient.lua

Copyright 2015 Simon Peter

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

]]--

module("luci.controller.admin.vclient", package.seeall)

function index()
	local uci = require("luci.model.uci").cursor()
	local page

	page = node("admin", "heating")
	page.target = firstchild()
	page.title  = _("Heating")
	page.order  = 80
	page.index  = true

	page = node("admin", "heating", "vclient")
	page.target = template("admin_heating/vclient")
	page.title  = _("Control")
	page.order  = 60

	page = entry({"admin", "heating", "diag_read"}, call("diag_read"), nil)
	page.leaf = true
end


function diag_command(cmd, addr)
	if addr and addr:match("^[a-zA-Z0-9%-%.:_]+$") then
		luci.http.prepare_content("text/plain")

		local util = io.popen(cmd % addr)
		if util then
			while true do
				local ln = util:read("*l")
				if not ln then break end
				luci.http.write(ln)
				luci.http.write("\n")
			end

			util:close()
		end

		return
	end

	luci.http.status(500, "Bad address")
end

function diag_read(addr)
	diag_command("vclient -h 127.0.0.1:3002 -c %q 2>&1", addr)
end
