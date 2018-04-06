ActiveAdmin.register Event do
  permit_params :name, :description, :image_url,
    performances_attributes: [:id, :start_time, :end_time, :_destroy]
  
  config.sort_order = "name_asc"
  
  filter :name
  filter :description
  
  index do
    selectable_column
    id_column
    column :name
    column :description
    actions
  end
  
  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :name
      f.input :description
      f.input :image_url
    end
    f.inputs do
      f.has_many :performances, heading: "Performances",
                                allow_destroy: true do |fp|
        fp.input :start_time, as: :string, placeholder: "YYYY-MM-DD HH:MM"
        fp.input :end_time, as: :string, placeholder: "YYYY-MM-DD HH:MM"
      end
    end
    f.actions
  end
end
