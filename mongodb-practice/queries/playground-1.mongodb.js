// 30 BEGINNER MONGODB PRACTICE QUESTIONS
/* global use */
// MongoDB Playground
// Use Ctrl+Space inside a snippet or a string literal to trigger completions.

// The current database to use.
use("mongo_practice");

// 1. List all users.
db.users.find();

db.users.find(
  {},
  {
    _id: 1,
    name: 1,
    email: 1,
    city: 1,
  },
);

// 2. Find users from Bengaluru.
db.users.find({
  city: "Bengaluru",
});

db.users.find({ city: "Bengaluru" }, { name: 1, email: 1, city: 1 });

// 3. Find products priced above 5000.
db.products.find({
  price: {
    $gt: 5000,
  },
});

db.products
  .find(
    { stockQty: { $gt: 5000 } },
    {
      _id: 1,
      name: 1,
      stockQty: 1,
    },
  )
  .sort({ price: 1 });

// 4. Find products with stock below 20.
db.products.find({
  stockQty: {
    $lt: 20,
  },
});

db.products
  .find(
    { stockQty: { $lt: 20 } },
    {
      _id: 1,
      name: 1,
      stockQty: 1,
    },
  )
  .sort({ stockQty: 1 });

// 5. Count users.
db.users.countDocuments();

// 6. Count products.
db.products.countDocuments();

// 7. Find cheapest product.
db.products.find().sort({ price: 1 }).limit(1);

db.products.aggregate([
  {
    $group: {
      _id: null,
      minPrice: { $min: "$price" },
    },
  },
  {
    $lookup: {
      from: "products",
      localField: "minPrice",
      foreignField: "price",
      as: "products",
    },
  },
  {
    $unwind: "$products",
  },
  {
    $replaceWith: "$products",
  },
]);

// 8. Find most expensive product.
db.products.find().sort({ price: -1 }).limit(1);

// 9. Average product price.
db.products.aggregate([
  {
    $group: {
      _id: null,
      avgP: { $avg: "$price" },
    },
  },
]);

// 10. Orders above 10000.
db.orders
  .find({
    totalAmount: {
      $gt: 10000,
    },
  })
  .sort({ totalAmount: 1 });

// 11. Count orders by status.
db.orders.aggregate([
  {
    $group: {
      _id: "$status",
      count: { $sum: 1 },
    },
  },
]);

// 12. Count products by status.
db.products.aggregate([
  {
    $group: {
      _id: "$status",
      count: { $sum: 1 },
    },
  },
]);

// 13. Users who signed up after 2025-01-01.

// 14. Products with rating >= 4.5.
// 15. Orders from a city.
// 16. Distinct payment methods.
// 17. Total payment amount.
// 18. Maximum order amount.
// 19. Minimum order amount.
// 20. Average review rating.
// 21. Five-star reviews.
// 22. Sort products by price.
// 23. Top 10 expensive products.
// 24. 10 cheapest products.
// 25. Count users by city.
// 26. Count products by category.
// 27. Count orders by user.
// 28. Suppliers with rating > 4.5.
// 29. Inventory below reorder level.
// 30. Active coupons.
