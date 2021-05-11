CREATE OR REPLACE VIEW invoice_list AS (
    SELECT
         invoice.id,
		 invoice.party_from_id,
         invoice.invoice_number,
         reference_number.identifier as vendor_invoice_number,
         unit_of_measure.name as currency,
         invoice.date_invoiced,
         invoice.date_created,
         IF(invoice_type.name is not null, invoice_type.name, "Regular Invoice") as invoice_type,
         IF(invoice.date_paid is not null, "Paid", IF(invoice.date_submitted is not null, "Posted", "Pending")) as status,
         person.id as created_by_id,
         CONCAT(person.first_name, ' ', person.last_name) as created_by_name,
         CONCAT(party.code, ' ', party.name) as vendor,
         count(invoice_item.id) as item_count,
         sum(invoice_item.quantity/invoice_item.quantity_per_uom * invoice_item.amount) as total_value
    FROM invoice
    LEFT JOIN invoice_item ON invoice_item.invoice_id = invoice.id
    LEFT JOIN unit_of_measure ON unit_of_measure.id = invoice.currency_uom_id
    LEFT JOIN person ON person.id = invoice.created_by_id
    LEFT JOIN invoice_reference_number ON invoice_reference_number.invoice_reference_numbers_id = invoice.id
    LEFT JOIN reference_number ON invoice_reference_number.reference_number_id = reference_number.id AND reference_number.reference_number_type_id = 'VENDOR_INVOICE_NUMBER'
    LEFT JOIN party ON invoice.party_id = party.id
    LEFT JOIN invoice_type ON invoice.invoice_type_id = invoice_type.id
    GROUP BY invoice.id, reference_number.id
)
