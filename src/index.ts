import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

const cleanSlate = async () => {
  console.log("Deleting all...");
  await prisma.addOn.deleteMany();
  await prisma.door.deleteMany();
};

const createDoor = async (id: string) => {
  return prisma.door.upsert({
    where: { id },
    update: {},
    create: { id },
  });
};

const createAddOn = async (id: string, doorId: string) => {
  return prisma.addOn.upsert({
    where: { id },
    update: {},
    create: { id, doors: { connect: { id: doorId } } },
  });
};

const seed = async () => {
  console.log("Seeding database...");

  const amountAddOns = 10_000;

  const door = await createDoor("door-1");

  await Promise.all(
    Array(amountAddOns)
      .fill(0)
      .map((_, i) => createAddOn(`add-on-${i + 1}`, door.id))
  );
};

const deleteRelations = async () => {
  console.log("Deleting relations...");

  await prisma.door.update({
    where: { id: "door-1" },
    data: { addOns: { set: [] } },
  });
};

const run = async () => {
  await cleanSlate();
  await seed();
  await deleteRelations();
  console.log("Done!");
};

run();
