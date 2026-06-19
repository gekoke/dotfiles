package net.runelite.client.plugins.clicktominimize;

import net.runelite.client.config.Config;
import net.runelite.client.config.ConfigGroup;
import net.runelite.client.config.ConfigItem;
import net.runelite.client.config.Keybind;

@ConfigGroup("ClickToMinimize")
public interface ClickToMinimizeConfig extends Config
{
	@ConfigItem(
		keyName = "Actions",
		name = "List of Actions to Minimize",
		description = "Enter actions in the format 'Action: Target, Action: Target." +
			", E.g. <br>'Pick-Fruit: Sq'irk tree, <br>Mine: Crashed Star'"
	)
	default String actions()
	{
		return "--- Examples: ---, \n" +
				"#Pick-Fruit: Sq'irk tree, \n" +
				"#Mine: Crashed Star, \n" +
				"#Bait: Rod Fishing spot,\n" +
				"#Use: Hammer -> Infernal eel,\n" +
				"#Make: yew longbow,\n" +
				"#Make: Super defence(3),\n" +
				"#Attack: Guard,\n" +
				"\n\n" +
				"--- SPECIAL CASE ---\n" +
				"If an action has action::target, then " +
				"you need to add a \\:: to make it work. E.g. \n" +
				"#Make sets\\:: Cannonballs";
	}

	@ConfigItem(
		keyName = "ignoreCase",
		name = "Ignore Case",
		description = "Ignore text capitalization when matching actions and targets",
		position = 2
	)
	default boolean ignoreCase()
	{
		return true;
	}

	@ConfigItem(
		keyName = "ignoreFullInventory",
		name = "Don't Minimize on Full Inventory",
		description = "If enabled, will not minimize window whenever the inventory is completely full.",
		position = 3
	)
	default boolean ignoreFullInventory()
	{
		return false;
	}

	@ConfigItem(
		keyName = "checkNoTargets",
		name = "Check for No Targets",
		description = "Mainly used for menu options, e.g. at the grand exchange. Using 'Confirm: x' will make it so that when you press the confirm after inputting a trade, it will minimize.",
		position = 4
	)
	default boolean checkNoTargets()
	{
		return true;
	}

	@ConfigItem(
		keyName = "minimizeKeybind",
		name = "Minimize Keybind",
		description = "Keybind to minimize the screen",
		position = 5
	)
	default Keybind minimizeKeybind()
	{
		return Keybind.NOT_SET;
	}

	@ConfigItem(
			keyName = "holdToPreventMinimizeKeybind",
			name = "Hold to Prevent Minimize Keybind",
			description = "WARNING: Changing this to shift will prevent 'shift drop' items Hold this key to prevent the window from minimizing when clicking.",
			position = 6
	)
	default Keybind holdToPreventMinimizeKeybind()
	{
		return Keybind.NOT_SET;
	}

	@ConfigItem(
			keyName = "sendChatMessage",
			name = "Send Chat Message on Minimize",
			description = "If enabled, a message will be sent to the in-game chat when the window is minimized.",
			position = 7
	)
	default boolean sendChatMessage()
	{
		return true;
	}

	@ConfigItem(
			keyName = "logPlayerActions",
			name = "Log Player Actions",
			description = "If enabled, logs every action taken by the player to the game window. This helps to figure out how to enable some actions, as they're not always clear.",
			position = 8
	)
	default boolean logPlayerActions()
	{
		return false;
	}

	@ConfigItem(
			keyName = "sendToBack",
			name = "Send to Back instead of Minimize",
			description = "Sends the window to the back instead of minimizing it",
			position = 9
	)
	default boolean sendToBack()
	{
		return false;
	}
}
