/*
  Warnings:

  - You are about to drop the column `doorId` on the `AddOn` table. All the data in the column will be lost.

*/
BEGIN TRY

BEGIN TRAN;

-- DropForeignKey
ALTER TABLE [dbo].[AddOn] DROP CONSTRAINT [AddOn_doorId_fkey];

-- AlterTable
ALTER TABLE [dbo].[AddOn] DROP COLUMN [doorId];

-- CreateTable
CREATE TABLE [dbo].[_AddOnToDoor] (
    [A] NVARCHAR(1000) NOT NULL,
    [B] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [_AddOnToDoor_AB_unique] UNIQUE NONCLUSTERED ([A],[B])
);

-- CreateIndex
CREATE NONCLUSTERED INDEX [_AddOnToDoor_B_index] ON [dbo].[_AddOnToDoor]([B]);

-- AddForeignKey
ALTER TABLE [dbo].[_AddOnToDoor] ADD CONSTRAINT [_AddOnToDoor_A_fkey] FOREIGN KEY ([A]) REFERENCES [dbo].[AddOn]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[_AddOnToDoor] ADD CONSTRAINT [_AddOnToDoor_B_fkey] FOREIGN KEY ([B]) REFERENCES [dbo].[Door]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
