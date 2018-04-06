ActiveAdmin.register Performance do
  filter :event
  filter :start_time
  filter :end_time
  
  index do
    selectable_column
    id_column
    column :event
    column :start_time
    column :end_time
    actions
  end
  
  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :event
      f.input :start_time, as: :string
      f.input :end_time, as: :string
    end
    f.actions
  end
end
