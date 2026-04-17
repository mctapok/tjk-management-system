UPDATE users
set password = case
    when email = 'admin@tracker.local' then '$2a$10$0NgFt0bWVh9uel2hDrGym.rVBrdAzbe2gdhDvcTAlMZ8OKyz18.g2'
    when email = 'store@tracker.local' then '$2a$10$O7RFNtjzM3l0394yOA/cHuEnQIltwZKwgJouSlpAFngwLGe1odmZS'
    else password
end
where email in ('admin@tracker.local','store@tracker.local')

-- INSERT INTO  users (full_name, email, password, role)
-- VALUES ('Администратор', 'admin@tracker.local', '$2a$10$0NgFt0bWVh9uel2hDrGym.rVBrdAzbe2gdhDvcTAlMZ8OKyz18.g2', 'ADMIN'),
--        ('Кладовщик', 'store@tracker.local', '$2a$10$O7RFNtjzM3l0394yOA/cHuEnQIltwZKwgJouSlpAFngwLGe1odmZS', 'STOREKEEPER');