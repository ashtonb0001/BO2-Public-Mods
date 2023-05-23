main()
{
    level thread onPlayerConnect();
    level thread command_thread();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread create_hud(player);
    }
}

command_thread()
{
    level endon("end_game");
    while (true)
    {
        level waittill("say", message, player, isHidden);
        args = strTok(message, " ");
        command = args[0];

        switch (command)
        {
            case ".show":
                if (args.size >= 2)
                {
                    targetPlayer = findPlayerByName(args[1]);
                    if (isDefined(targetPlayer))
                    {
                        player thread show_other_player_balance(targetPlayer);
                    }
                }
                break;
            case ".hide":
                if (args.size >= 2)
                {
                    targetPlayer = findPlayerByName(args[1]);
                    if (isDefined(targetPlayer))
                    {
                        player thread hide_other_player_balance(targetPlayer);
                    }
                }
                break;
            default:
                break;
        }
    }
}

findPlayerByName(name)
{
    foreach (player in level.players)
    {
        if (player.name == name)
        {
            return player;
        }
    }
    return undefined;
}

show_other_player_balance(targetPlayer)
{
    // Create and display the HUD for the other player's bank balance
    hud_bank_other = newClientHudElem(self);
    hud_bank_other.horzAlign = "topleft";
    hud_bank_other.vertAlign = "topleft";
    hud_bank_other.x = 20;
    hud_bank_other.y = 20;
    hud_bank_other.alignX = "topleft";
    hud_bank_other.alignY = "topleft";
    hud_bank_other.font = "objective";
    hud_bank_other.fontScale = 1.5;
    hud_bank_other.archived = false;
    hud_bank_other.alpha = 1;
    hud_bank_other setText("^7" + targetPlayer.name + "'s Bank Balance: ^2" + targetPlayer.account_value * 1000);

    // Store the HUD element in the player's instance so we can remove it later
    self.hud_bank_other = hud_bank_other;
}

hide_other_player_balance(targetPlayer)
{
    // Check if the HUD element exists and remove it
    if (isDefined(self.hud_bank_other))
    {
        self.hud_bank_other destroy();
        self.hud_bank_other = undefined;
    }
}

create_hud(player)
{
    if (!isDefined(player))
        return;

    // Create the HUD element
    hud_bank = newClientHudElem(player);
    hud_bank.horzAlign = "middle";
    hud_bank.vertAlign = "bottom";
    hud_bank.x = 255;
    hud_bank.y = 20;
    hud_bank.alignX = "middle";
    hud_bank.alignY = "bottom";
    hud_bank.font = "objective";
    hud_bank.fontScale = 1.5;
    hud_bank.archived = false;
    hud_bank.alpha = 1;

    // Update the bank balance
    hud_bank_thread(player, hud_bank);
}

hud_bank_thread(player, hud_bank)
{
    level endon("game_ended");

    while (true)
    {
        bank_balance = player.account_value * 1000;
        hud_bank setText("^7Bank Balance: ^2" + bank_balance);
        wait 1;
    }
}
