module MyModule::P2PCarRental {

    use aptos_framework::signer;
    use std::vector;
    use aptos_framework::account;

    /// Struct representing a car listed for rental.
    struct Car has store, key {
        owner: address,         // Address of the car owner
        model: vector<u8>,      // Model name of the car
        rental_price: u64,      // Price for renting the car
        is_available: bool,     // Whether the car is available for rent
    }

    /// Function to list a car for rental.
    public fun list_car(owner: &signer, model: vector<u8>, rental_price: u64) {
        // Ensure that the car does not already exist for this owner
        let owner_address = signer::address_of(owner);
        assert!(!exists<Car>(owner_address), 1);

        let car = Car {
            owner: owner_address,
            model,
            rental_price,
            is_available: true,
        };

        // Move the car struct to the owner's account storage
        move_to(owner, car);
    }

    /// Function to rent a car, updating its status.
    public fun rent_car(renter: &signer, owner_address: address) acquires Car {
        let car = borrow_global_mut<Car>(owner_address);

        // Ensure the car is available for rent
        assert!(car.is_available, 2);

        // Mark the car as rented (not available)
        car.is_available = false;

        // Payment and insurance are assumed to be handled off-chain
    }

    /// View function to check car details
    public fun get_car_details(owner_address: address): (vector<u8>, u64, bool) acquires Car {
        let car = borrow_global<Car>(owner_address);
        (car.model, car.rental_price, car.is_available)
    }
}
