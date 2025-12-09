//
//  CartStoreTest.swift
//  OnlineStoreMVTests
//
//  Created by Pedro Rojas on 07/03/24.
//

import XCTest
import Testing
@testable import OnlineStoreMV

extension Tag {
    @Tag static let price: Self
    @Tag static let product: Self
    @Tag static let quantity: Self
}

// We can have both XCTest and Swift Testing in the same file
// We can migrate gradually haha
let products = [
    Product(
        id: 1,
        title: "test1",
        price: 123.12,
        description: "",
        category: "",
        imageURL: URL(string: "www.apple.com")!
    ),
    Product(
        id: 2,
        title: "test2",
        price: 77.56,
        description: "",
        category: "",
        imageURL: URL(string: "www.apple.com")!
    ),
    Product(
        id: 3,
        title: "test2",
        price: 91.0,
        description: "",
        category: "",
        imageURL: URL(string: "www.apple.com")!
    )
]

let cartItems = [
    CartItem(
        product: products[0],
        quantity: 3
    ),
    CartItem(
        product: products[1],
        quantity: 1
    ),
    CartItem(
        product: products[2],
        quantity: 2
    ),
]

@Suite("Cart Store Tests")
struct CartStoreTest {
    @Test(
        "Get total amount to pay as string",
        .tags(.price)
    )
    func totalAmountString() {
        let cartStore = CartStore(
            cartItems: cartItems,
            apiClient: .testSuccess
        )
        
        //        let expected = "$628.92"
        //        let actual = cartStore.totalPriceString
        
        withKnownIssue(
            "This quantity is failing sometimes"
        ) {
            #expect(cartStore.totalPriceString == "$628.9")
        }
    }
    
    // We can also have a subset of tests
    @Suite(
        "Subtracting Quantity on Cart Items",
        .tags(.quantity)
    )
    struct SubtractingTest {
        @Test
        func quantityFromItemInCart() {
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            cartStore.removeFromCart(product: products[0])
            cartStore.removeFromCart(product: products[2])
            let quantity = cartStore.cartItems.reduce(0) {
                $0 + $1.quantity
            }
            
            #expect(quantity == 4)
        }
        
        @Test
        func quantityFromItemInCartUntilMakeItZero() {
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            cartStore.removeFromCart(product: products[0])
            cartStore.removeFromCart(product: products[1])
            cartStore.removeFromCart(product: products[2])
            cartStore.removeFromCart(product: products[2])
            
            let quantity = cartStore.cartItems.reduce(0) {
                $0 + $1.quantity
            }
            
            #expect(quantity == 2)
        }
    }
    
    @Suite("Removing Items from Cart")
    struct RemovingTest {
        @Test(
            .tags(.product),
            arguments: [
                (products[0], 3),
                (products[1], 5),
                (products[2], 4)
            ]
        )
        func oneProductFromCart(
            product: Product,
            expectedQuantity: Int
        ) {
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            cartStore.removeAllFromCart(product: product)
            let quantity = cartStore.cartItems.reduce(0) {
                $0 + $1.quantity
            }
            
            #expect(cartStore.cartItems.count == 2)
            #expect(quantity == expectedQuantity)
        }
        
        @Test(.tags(.product))
        func allItemsFromCart() {
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            cartStore.removeAllItems()
            #expect(cartStore.cartItems.isEmpty)
        }
    }
    
    @Suite("Quantity Tests")
    struct QuantityTesting {
        @Test(.tags(.product))
        func productInCart() {
            let cartItems = [
                CartItem(
                    product: products[0],
                    quantity: 4
                )
            ]
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            let quantity = cartStore.quantity(for: products[0])
            #expect(quantity == 4)
        }
        
        @Test(.tags(.product))
        func nonExistingProudctInCart() {
            let unknownProduct = Product(
                id: 1000,
                title: "test1",
                price: 123.12,
                description: "",
                category: "",
                imageURL: URL(string: "www.apple.com")!
            )
            let cartItems = [
                CartItem(
                    product: products[0],
                    quantity: 4
                )
            ]
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            let quantity = cartStore.quantity(for: unknownProduct)
            #expect(quantity == 0)
        }
    }
    
    @Suite("Add Quantity Tests")
    struct AddingTest {
        @Test(.tags(.quantity))
        func quantityFromExistingItemInCart() {
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            cartStore.addToCart(product: products[0])
            cartStore.addToCart(product: products[2])
            cartStore.addToCart(product: products[2])
            let quantity = cartStore.cartItems.reduce(0) {
                $0 + $1.quantity
            }
            
            #expect(quantity == 9)
        }
        
        @Test(.tags(.quantity))
        func quantityFromNewItemInCart() {
            let cartItems = [
                CartItem(
                    product: products[0],
                    quantity: 3
                )
            ]
            let cartStore = CartStore(
                cartItems: cartItems,
                apiClient: .testSuccess
            )
            
            cartStore.addToCart(product: products[0])
            cartStore.addToCart(product: products[1])
            
            #expect(cartStore.cartItems.count == 2)
        }
    }
    
}

@Suite(.serialized)
struct ParallelTesting_Demo {
    
    let state = StateTest()
    
    @Test
    func test1() {
        state.addNumber([4, 5])
        #expect(state.count == 5)
        #expect(state.removeLastNumber()! == 5)
    }
    
    @Test
    func test2() {
        state.addNumber([6, 7])
        #expect(state.count == 6)
        #expect(state.removeLastNumber()! == 7)
    }
    
    @Test
    func test3() {
        state.addNumber([8, 9])
        #expect(state.count == 7)
        #expect(state.removeLastNumber()! == 9)
    }
}


struct HeavyTestDemo {
    
    @Test(.timeLimit(.minutes(1)))
    func calculateExpensiveOperation() async throws {
        
        // Simulate a very heavy task (2 minutes)
        try await Task.sleep(nanoseconds: 120 * 1_000_000_000)
        
        // This line probably never runs if timeout triggers
        #expect(true)
    }
}

enum ContainerError: Error, Equatable {
    case empty
}

struct MyContainer {
    private var storage: [Int] = []
    
    mutating func add(_ value: Int) {
        storage.append(value)
    }
    
    mutating func removeLast() -> Int? {
        storage.popLast()
    }
    
    mutating func removeAll() throws {
        guard !storage.isEmpty else {
            throw ContainerError.empty
        }
        storage.removeAll()
    }
}

var container = MyContainer()

struct ConditionalTests {
    
    @Test
    func fetchingLastElement() async throws {
        container.add(4)
        
        let last = container.removeLast()
        
        let unwrapped = try #require(last, "last value should be 4")
        #expect(unwrapped == 4)
    }
    
    @Test
    func removeAllElements() async throws {
        try #require(throws: ContainerError.empty) {
            try container.removeAll()
        }
    }
}

