import { Client } from 'discord.js';
import { config } from 'dotenv';

config();

(function main() {
  const client = new Client();

  client.on('message', async (message) => {
    if (message.author.bot) return;

    if (message.content === '!ping') {
      message.channel.send('pong');
    }
  });

  client.once('ready', () => {
    console.log('Connected to Discord successfully!');
  });
  client.login(process.env.DISCORD_TOKEN);
})();
