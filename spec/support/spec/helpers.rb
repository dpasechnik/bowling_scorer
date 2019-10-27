def expect_save_ok(record)
  expect([record.save, record.errors.to_a]).to eq([true, []])
end

def me
  described_class.to_s.underscore.to_sym
end