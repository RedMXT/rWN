
WebHook = "https://discord.com/api/webhooks/855123504865476689/q0quAwu253iuxjDsioMrbFtcg7SdIWnEGSQdxRjl7Sb8DusRc7FBgPlPnWv8CHZgwncd"
WebHook2 = "https://discord.com/api/webhooks/855123545935970374/sHCxiLmFB_9pBCj8ZHrluLqbO7OG4s66Bxh5e0B0TmDvp0GyGz5nqPUuWro8FDX9E7H4"
Name = "Weazle NEWS"
Logo = "https://th.bing.com/th/id/R.6bb1c409ac7e4230edb32c434915a352?rik=te0FlzYVHWvPCg&pid=ImgRaw&r=0" -- He must finish by .png or .jpg
LogsBlue = 3447003
LogsRed = 15158332
LogsYellow = 15844367
LogsOrange = 15105570
LogsGrey = 9807270
LogsPurple = 10181046
LogsGreen = 3066993
LogsLightBlue = 1752220


RegisterNetEvent('rWN:log')
AddEventHandler('rWN:log', function(Webhook, Color, Title, Description)
	Ise_Logs(Webhook, Color, Title, Description)
end)



function Ise_Logs(webhook, Color, Title, Description)
	local Content = {
	        {
	            ["color"] = Color,
	            ["title"] = Title,
	            ["description"] = Description,
		        ["footer"] = {
	                ["text"] = Name,
	                ["icon_url"] = Logo,
	            },
	        }
	    }
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = Name, embeds = Content}), { ['Content-Type'] = 'application/json' })
end
