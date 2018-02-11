require 'rails_helper'

RSpec.describe ShoppingCart, type: :model do
  let(:user) { instance_double(User) }
  let(:cart) { ShoppingCart.new(user) }
  
  let(:romeo_and_juliet) { instance_double(Event, name: "Romeo and Juliet") }
  let(:julius_ceasar) { instance_double(Event, name: "Julius Ceasar") }
  
  let(:romeo_and_juliet_performance) { instance_spy(Performance,
    id: 1, event: romeo_and_juliet) }
  let(:julius_ceasar_performance) { instance_spy(Performance,
    id: 2, event: julius_ceasar) }
  
  let(:ticket_1) { instance_double(Ticket,
    event: romeo_and_juliet, performance: romeo_and_juliet_performance,
    price: Money.new(1500)) }
  let(:ticket_2) { instance_double(Ticket,
    event: romeo_and_juliet, performance: romeo_and_juliet_performance,
    price: Money.new(1500)) }
  let(:ticket_3) { instance_double(Ticket,
    event: julius_ceasar, performance: julius_ceasar_performance,
    price: Money.new(1500)) }
    
  before(:example) do
    allow(user).to receive(:tickets_in_cart).
      and_return([ticket_1, ticket_2, ticket_3])
  end
  
  it "retrieves the list of events" do
    expect(cart.events).to eq([julius_ceasar, romeo_and_juliet])
  end
  
  it "retrieves the number of tickets for each performance" do
    expect(cart.performance_count).to eq(1 => 2, 2 => 1)
  end
  
  it "retrieves the list of performances for the event" do
    expect(cart.performances_for(romeo_and_juliet)).
      to eq([romeo_and_juliet_performance])
  end
  
  it "calculates subtotal for the performance" do
    expect(cart.subtotal_for(romeo_and_juliet_performance)).
      to eq(Money.new(3000))
  end
  
  it "calculates entire total" do
    expect(cart.total_cost).to eq(Money.new(4500))
  end
end