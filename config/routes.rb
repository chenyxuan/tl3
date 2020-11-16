require_dependency "tl3_constraint"

Tl3::Engine.routes.draw do
  get "/" => "tl3#index", constraints: Tl3Constraint.new
  get "/actions" => "actions#index", constraints: Tl3Constraint.new
  get "/actions/:id" => "actions#show", constraints: Tl3Constraint.new
end
