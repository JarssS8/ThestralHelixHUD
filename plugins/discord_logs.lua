PLUGIN.name = "Discord Logs"
PLUGIN.author = "JarssS8"
PLUGIN.description = "Discord logs from helix."

/*
    reqwest is a library that allows you to make HTTP requests in Garry's Mod.
    Download it from here: https://github.com/WilliamVenner/gmsv_reqwest/releases
    Put the .dll file in garrysmod/lua/bin

    Put URL of the webhook in the GetLogsWebHook hook.
    ATTENTION: Put it on SERVER side file avoiding to be leaked.
    Example:
    hook.Add("GetLogsWebHook", "DiscordLogs", function()
        return "https://discord.com/api/webhooks/XXXXXXXXXXXX/XXXXXXXXXXXX"
    end)
*/

ix.config.Add(
    "enableDiscordLogs",
    true,
    "Enable discord logs",
    nil,
    {
        category = "Discord Logs"
    }
)

require("reqwest")
if SERVER then
    function PLUGIN:InitializedPlugins()
        self.webhook = hook.Run("GetLogsWebHook")
    end

    function PLUGIN:SendWebhookMessage(message)
        if not self.webhook then return end
        if not reqwest then return end
        reqwest(
            {
                method = "POST",
                url = self.webhook,
                timeout = 1,
                body = util.TableToJSON(
                    {
                        content = message
                    }
                ),
                type = "application/json",
                headers = {
                    ["User-Agent"] = "My User Agent"
                }
            }
        )
    end

    do
        local HANDLER = {}

        function HANDLER.Write(client, message)
            if not ix.config.Get("enableDiscordLogs", true) then return end
            hook.Run("SendWebhookMessage", message)
        end

        ix.log.RegisterHandler("Discord", HANDLER)
    end
end