--
-- Copyright (C) 2016 iMega ltd Dmitry Gavriloff (email: info@imega.ru),
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program. If not, see <http://www.gnu.org/licenses/>.

local json = require "cjson"
local sha1 = require "sha1"

local webhook = ngx.var.webhook

ngx.req.read_body()
local body = ngx.req.get_body_data()

local jsonErrorParse, data = pcall(json.decode, body)
if not jsonErrorParse then
    ngx.status = ngx.HTTP_BAD_REQUEST
    ngx.say("400 HTTP_BAD_REQUEST")
    ngx.exit(ngx.status)
end

if data.ref ~= "refs/heads/master" then
    ngx.status = ngx.HTTP_OK
    ngx.say("200 HTTP_OK")
    ngx.exit(ngx.status)
end

ngx.eof()

os.execute("cd /tmp; git clone " .. data.repository.clone_url .. "; cd /tmp/" .. data.repository.name .. "; make deploy -I ../; cd /;rm -rf /tmp/" .. data.repository.name)

local jsonErrorParse, data = pcall(json.encode,{
    username = "Xodos",
    icon_emoji = ":xodos:",
    attachments = {
        {
            color = "#36a64f",
            author_name = data.head_commit.committer.name,
            title = "Показать правки",
            title_link = data.head_commit.url,
            text = data.head_commit.message,
            fields = {
                { title = "Deployment success" },
            }
        },
    },
})

if not jsonErrorParse then
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    ngx.say("500 HTTP_INTERNAL_SERVER_ERROR")
    ngx.exit(ngx.status)
end

os.execute("curl -X POST -d '" .. data .. "' " .. webhook)
