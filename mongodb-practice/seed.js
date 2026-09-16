// MongoDB practice database
// Run with: mongosh mongodb://localhost:27017/mongo_practice seed.js

db.getSiblingDB("mongo_practice").dropDatabase();
const cities=["Bengaluru","Mumbai","Delhi","Hyderabad","Chennai","Pune","Kolkata","Ahmedabad","Jaipur","Kochi"];
const countries=["India","USA","UK","Germany","Singapore","Australia"];
const methods=["card","upi","netbanking","wallet","cod"];
const orderStatuses=["pending","confirmed","shipped","delivered","cancelled","returned"];
const carriers=["DHL","FedEx","BlueDart","Delhivery","DTDC"];
const warehouses=["BLR-01","MUM-01","DEL-01","HYD-01","CHE-01"];
const pick=a=>a[Math.floor(Math.random()*a.length)];
const money=(min,max)=>Math.round((min+Math.random()*(max-min))*100)/100;
const date=()=>new Date(2023+Math.floor(Math.random()*4),Math.floor(Math.random()*12),1+Math.floor(Math.random()*27));

let users=[], addresses=[], categories=[], suppliers=[], products=[], inventory=[], orders=[], orderItems=[], payments=[], shipments=[], reviews=[], coupons=[];

for(let i=1;i<=10000;i++){
  users.push({_id:i,name:`User ${i}`,email:`user${i}@example.com`,gender:pick(["male","female","other"]),birthDate:new Date(1970+Math.floor(Math.random()*35),Math.floor(Math.random()*12),1+Math.floor(Math.random()*27)),city:pick(cities),country:pick(countries),signupDate:date(),status:pick(["active","inactive","blocked"])});
  categories.push({_id:i,name:`${pick(["Electronics","Home","Books","Fitness","Fashion","Beauty","Grocery","Toys","Automotive","Office"])} Subcategory ${i}`,parentCategoryId:i<=10?null:1+Math.floor(Math.random()*Math.min(100,i-1)),isActive:i%11!==0});
  suppliers.push({_id:i,name:`Supplier ${i}`,city:pick(cities),country:pick(countries),rating:money(3,5),joinedDate:date(),status:pick(["active","inactive"])});
  const cost=money(50,5000);
  products.push({_id:i,categoryId:1+Math.floor(Math.random()*10000),supplierId:1+Math.floor(Math.random()*10000),name:`Product ${i}`,sku:`SKU-${String(i).padStart(6,"0")}`,price:money(cost*1.1,cost*2.2),costPrice:cost,stockQty:Math.floor(Math.random()*501),rating:money(2.5,5),createdAt:date(),status:pick(["active","inactive","discontinued"])});
  inventory.push({_id:i,productId:i,warehouse:pick(warehouses),quantity:Math.floor(Math.random()*501),reorderLevel:10+Math.floor(Math.random()*91),lastRestocked:date()});
  coupons.push({_id:i,code:`CPN${i}`,discountPercent:pick([5,10,15,20,25,30,40]),minOrderAmount:money(500,5000),maxDiscount:money(100,3000),startDate:date(),endDate:date(),usageLimit:10+Math.floor(Math.random()*991),status:pick(["active","expired","disabled"])});
}
for(let i=1;i<=15000;i++) addresses.push({_id:i,userId:1+(i-1)%10000,addressType:pick(["home","work"]),line1:`${1+Math.floor(Math.random()*999)} Main Street`,city:pick(cities),state:`State ${1+Math.floor(Math.random()*30)}`,postalCode:String(100000+Math.floor(Math.random()*900000)),country:"India",isDefault:i%3===0});
for(let i=1;i<=12000;i++){
  orders.push({_id:i,userId:1+Math.floor(Math.random()*10000),orderDate:date(),status:pick(orderStatuses),totalAmount:money(100,25000),shippingCity:pick(cities),couponCode:Math.random()<.35?`CPN${1+Math.floor(Math.random()*10000)}`:null});
  payments.push({_id:i,orderId:i,paymentMethod:pick(methods),amount:money(100,25000),paymentDate:date(),status:pick(["success","failed","refunded"])});
  shipments.push({_id:i,orderId:i,carrier:pick(carriers),trackingNumber:`TRK${String(i).padStart(10,"0")}`,shippedDate:date(),deliveredDate:date(),status:pick(["processing","in_transit","delivered","lost","returned"])});
}
for(let i=1;i<=36000;i++) orderItems.push({_id:i,orderId:1+Math.floor(Math.random()*12000),productId:1+Math.floor(Math.random()*10000),quantity:1+Math.floor(Math.random()*5),unitPrice:money(50,6000),discount:pick([0,0,0,5,10,15,20])});
for(let i=1;i<=20000;i++) reviews.push({_id:i,userId:1+Math.floor(Math.random()*10000),productId:1+Math.floor(Math.random()*10000),rating:1+Math.floor(Math.random()*5),title:pick(["Great","Good","Average","Poor","Excellent"]),reviewText:`Review text ${i}`,createdAt:date()});

db.users.insertMany(users); db.addresses.insertMany(addresses); db.categories.insertMany(categories);
db.suppliers.insertMany(suppliers); db.products.insertMany(products); db.inventory.insertMany(inventory);
db.orders.insertMany(orders); db.orderItems.insertMany(orderItems); db.payments.insertMany(payments);
db.shipments.insertMany(shipments); db.reviews.insertMany(reviews); db.coupons.insertMany(coupons);

db.users.createIndex({city:1});
db.orders.createIndex({userId:1,orderDate:-1});
db.orders.createIndex({status:1});
db.orderItems.createIndex({orderId:1});
db.orderItems.createIndex({productId:1});
db.products.createIndex({categoryId:1});
db.products.createIndex({supplierId:1});
db.reviews.createIndex({productId:1});

print("Seed complete.");
