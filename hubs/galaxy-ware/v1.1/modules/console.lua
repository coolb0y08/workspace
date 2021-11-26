local Console = {
    ["RichText"] = true;
    ["RemoveTestService"] = true;
}

Console.DescendantAdded = game:GetService("CoreGui").DescendantAdded:Connect(function(t)
    if t.Name == "msg" then
        t.RichText = Console.RichText;

        if Console.RemoveTestService and string.find(t.Text, "TestService:") then
            local Text = t.Text:gsub("TestService: ", "");
            t.Text = Text;
        end;
    end;
end);

return Console
