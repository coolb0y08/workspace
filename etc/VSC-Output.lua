-- https://marketplace.visualstudio.com/items?itemName=Alleexxii.synapseoutput

local WebSocket = (syn and syn.websocket) or (getexecutorname() == "ScriptWare" and WebSocket) or nil;
local LogService, ScriptContext, Players = game:GetService("LogService"), game:GetService("ScriptContext"), game:GetService("Players");

if(WebSocket ~= nil)then
    getgenv()["VSC-Output"] = {
        ["Connection"] = (WebSocket.connect("ws://localhost:34523/"));
        
        ["RedirectErrors"] = (false);
        
        ["RedirectOutput"] = (false);

        ["CleanOutputOnLeave"] = (false);
        
        ["ClearOutput"] = (function()
            getgenv()["VSC-Output"].Connection:Send("ClearOutput")
        end);
        
        ["DisableEO"] = (function()
            getgenv()["VSC-Output"].Connection:Send("DisableErrorOutput")
        end);
        
        ["Send"] = (function(t)
            getgenv()["VSC-Output"].Connection:Send(t)
        end);
        
        ["OutputMessage"] = "{message}";

        ["ErrorMessage"] = "{message}";
        
        ["Destroy"] = (function(t)
            if(WebSocket ~= nil and getgenv()["VSC-Output"].Connection) then
                if(getgenv()["VSC-Output"].Events.MessageOut and getgenv()["VSC-Output"].Events.ErrorDetailed)then
                    getgenv()["VSC-Output"]:DisableEO()
                    getgenv()["VSC-Output"]:ClearOutput()

                    getgenv()["VSC-Output"].Send("Disconnected [Destroy() was called] ["..t or ("03").."]")
                    getgenv()["VSC-Output"].Events.ErrorDetailed:Disconnect()
                    getgenv()["VSC-Output"].Events.MessageOut:Disconnect()
                    getgenv()["VSC-Output"] = nil;
                end
            elseif(getgenv()["VSC-Output"].Connection == nil) then
                print("Couldn't connect to websocket [02]")
            end
        end);
        
        ["Events"] = {};
    }

    if(WebSocket ~= nil and getgenv()["VSC-Output"].Connection)then
        getgenv()["VSC-Output"].Events.MessageOut = LogService.MessageOut:Connect(function(m)
            if(getgenv()["VSC-Output"].RedirectOutput == true)then
                getgenv()["VSC-Output"].Send(string.gsub(getgenv()["VSC-Output"].OutputMessage, "{message}", m))
            end
        end)
        
        getgenv()["VSC-Output"].Events.ErrorDetailed = ScriptContext.ErrorDetailed:Connect(function(m)
            if(getgenv()["VSC-Output"].RedirectErrors == true)then
                getgenv()["VSC-Output"].Send(string.gsub(getgenv()["VSC-Output"].OutputMessage, "{message}", m))
            end
        end)

        getgenv()["VSC-Output"].Events.PlayerLeft = Players.PlayerRemoving:Connect(function(p)
            if(p == Players.LocalPlayer) and (getgenv()["VSC-Output"].CleanOutputOnLeave) then
                getgenv()["VSC-Output"].ClearOutput()
            end
        end)
        
        getgenv()["VSC-Output"].Send("Loaded")
    elseif(getgenv()["VSC-Output"].Connection == nil) then
        print("Couldn't connect to websocket [02]")
    end
else
    print("Couldn't find websocket function [01]")
end

return(getgenv()["VSC-Output"])
