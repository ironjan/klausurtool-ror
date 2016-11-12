BEGIN;

INSERT INTO folder_instance_archive_copies (`folder_title`, `barcode_id`, `archived_old_lend_out_id`, `created_at`, `updated_at`)
SELECT os.title, ois.barcodeId, aos.id, NOW(), NOW() FROM archived_old_lend_outs as aos
JOIN archived_old_lend_outs_old_folder_instances ON aos.id = `archived_old_lend_out_id`
JOIN old_folder_instances as ois ON ois.id = `old_folder_instance_id`
JOIN old_folders as os ON os.id = `old_folder_id`;

COMMIT;
