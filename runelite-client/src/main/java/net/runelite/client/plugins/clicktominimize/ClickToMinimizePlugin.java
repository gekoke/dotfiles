package net.runelite.client.plugins.clicktominimize;

import com.google.inject.Provides;
import javax.inject.Inject;
import lombok.extern.slf4j.Slf4j;
import net.runelite.api.ChatMessageType;
import net.runelite.api.Client;
import net.runelite.api.InventoryID;
import net.runelite.api.events.MenuOptionClicked;
import net.runelite.client.chat.ChatMessageManager;
import net.runelite.client.chat.QueuedMessage;
import net.runelite.client.config.ConfigManager;
import net.runelite.client.eventbus.Subscribe;
import net.runelite.client.input.KeyManager;
import net.runelite.client.plugins.Plugin;
import net.runelite.client.plugins.PluginDescriptor;

import javax.swing.JFrame;
import java.awt.Frame;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static net.runelite.client.util.Text.removeTags;

@Slf4j
@PluginDescriptor(
		name = "Click To Minimize"
)
public class ClickToMinimizePlugin extends Plugin
{
	@Inject
	private Client client;

	@Inject
	private ClickToMinimizeConfig config;

	@Inject
	private KeyManager keyManager;

	@Inject
	private ClickToMinimizeKeyListener keyListener;

	@Inject
	private ChatMessageManager chatMessageManager;

	private long lastMessageTime = 0;

	@Override
	protected void startUp() throws Exception
	{
		log.info("Click To Minimize started!");
		keyManager.registerKeyListener(keyListener);
	}

	@Override
	protected void shutDown() throws Exception
	{
		keyManager.unregisterKeyListener(keyListener);
		log.info("Click To Minimize stopped!");
	}

	@Provides
	ClickToMinimizeConfig provideConfig(ConfigManager configManager)
	{
		return configManager.getConfig(ClickToMinimizeConfig.class);
	}

	public Map<String, List<String>> parseActions(String actionConfig, boolean ignoreCase)
	{
		Map<String, List<String>> actionsMap = new HashMap<>();
		String[] actions = actionConfig.split(",");
		for (String action : actions)
		{
			String[] parts = action.trim().replace("\\:", "[COLON]").split(":");
			if (parts.length == 2)
			{
				String key = ignoreCase ? parts[0].trim().replace("[COLON]", ":").toLowerCase() : parts[0].trim().replace("[COLON]", ":");
				String value = ignoreCase ? parts[1].trim().toLowerCase() : parts[1].trim();
				actionsMap.computeIfAbsent(key, k -> new ArrayList<>()).add(value);
			}
		}
		return actionsMap;
	}

	@Subscribe
	public void onMenuOptionClicked(MenuOptionClicked event)
	{
		if (keyListener.isPreventMinimizeHeld())
		{
			return; // Exit early if the key is held
		}

		boolean ignoreCase = config.ignoreCase();
		boolean checkNoTargets = config.checkNoTargets();
		Map<String, List<String>> actionsMap = parseActions(config.actions(), ignoreCase);
		String action = ignoreCase ? removeTags(event.getMenuOption()).toLowerCase() : removeTags(event.getMenuOption());
		String target = ignoreCase ? removeTags(event.getMenuTarget()).toLowerCase() : removeTags(event.getMenuTarget());

		// Log the player's action if the option is enabled
		if (config.logPlayerActions())
		{
			chatMessageManager.queue(QueuedMessage.builder()
					.type(ChatMessageType.GAMEMESSAGE)
					.runeLiteFormattedMessage("Click To Minimize, logging action on target: \"" + event.getMenuOption() + ": " + event.getMenuTarget() + "\"")
					.build());
		}

		for (Map.Entry<String, List<String>> entry : actionsMap.entrySet())
		{
			String configAction = entry.getKey();
			List<String> configTargets = entry.getValue();

			if (action.equals(configAction))
			{
				for (String configTarget : configTargets)
				{
					if (target.contains(configTarget) || (checkNoTargets && target.isEmpty()))
					{
						minimizeWindow();
						return;
					}
				}
			}
		}
	}

	public boolean isInventoryFull()
	{
		int itemCount = client.getItemContainer(InventoryID.INVENTORY).count();
		return itemCount >= 28;
	}

	public void minimizeWindow()
	{
		if (config.ignoreFullInventory() && isInventoryFull())
		{
			log.info("Inventory is full. Skipping window minimize.");
			return;
		}

		JFrame frame = (JFrame) javax.swing.SwingUtilities.getWindowAncestor(client.getCanvas());
		if (frame != null)
		{
			if (config.sendToBack())
			{
				frame.toBack();
			}
			else
			{
				frame.setState(Frame.ICONIFIED);
			}

			long currentTime = System.nanoTime();
			// Check if enough time has passed since the last message (5 seconds)
			if (config.sendChatMessage() && (currentTime - lastMessageTime) >= 5_000_000_000L)
			{
				chatMessageManager.queue(QueuedMessage.builder()
						.type(ChatMessageType.GAMEMESSAGE)
						.runeLiteFormattedMessage("Window has been minimized by the Click To Minimize plugin.")
						.build());

				// Update the last message time
				lastMessageTime = currentTime;
			}
		}
		else
		{
			log.warn("No frame found to minimize!");
		}
	}
}
