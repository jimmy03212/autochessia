import {
  OverridableComponent,
  getComponentValueStrict,
} from "@latticexyz/recs";
import { ClientComponents } from "../mud/createClientComponents";
import { SetupNetworkResult } from "../mud/setupNetwork";
import { uuid } from "@latticexyz/utils";
import { initEntity } from "@/constant";
import { decodeHero } from "@/lib/utils";

export function opRunSellHero(
  { playerEntity }: SetupNetworkResult,
  { Player, ShopConfig }: ClientComponents,
  index: number
): string {
  const sellId = uuid();

  const oldPlayerData = getComponentValueStrict(Player, playerEntity);
  // check hero not null
  const creatureData = oldPlayerData.inventory[index];

  if (creatureData === 0) {
    throw new Error("Null hero");
  }

  const { tier } = decodeHero(creatureData);

  // remove from hero inventory
  const newInventory = oldPlayerData.inventory.map((v, i) => {
    if (i === index) {
      return 0;
    }
    return v;
  });

  const price = Number(tier);

  // add coin back
  const newCoin = oldPlayerData.coin + price;

  Player.addOverride(sellId, {
    entity: playerEntity,
    value: {
      inventory: newInventory,
      coin: newCoin,
    },
  });

  return sellId;
}
