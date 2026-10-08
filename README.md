# Superstore Profit and Discount Analysis

SQL analysis of the Global Super Store dataset to find which categories, sub-categories and markets are least profitable, and whether discounting explains it.

## Question
Which product categories, sub-categories and markets are least profitable, and does discounting explain it?

## Summary
- Every product category makes a profit, but **Furniture earns only a 6.9% margin**, roughly half that of the other two.
- **Tables is the only sub-category that loses money**: a -8.5% margin, or a loss of 64,083 on 757,042 of sales.
- **No market loses money, but EMEA earns only a 5.4% margin**, less than half the company-wide 11.6%.
- **Discounting explains the losses.** Orders discounted by more than 20% lose money, and orders discounted by more than 40% run at a **-74.1% margin**.
- Recommendation: cap discounts at 20% unless a manager approves them.

## Data
- Source: [Global Super Store Dataset](https://www.kaggle.com/datasets/apoorvaappz/global-super-store-dataset) by Apoorva Mahalingappa on Kaggle. Search the title on Kaggle to download it.
- 51,290 order lines, covering orders, products, customers, sales, discount and profit.
- The currency is not stated in the dataset, so figures are shown without a currency symbol.
- The dataset is not stored in this repository. Download it from Kaggle to run the queries.

## Tools
SQL (Google BigQuery)

## Method
1. Loaded the CSV into BigQuery as `superstore_raw`. The file used a different text encoding, so I converted it to UTF-8 before it would upload.
2. Checked the data: row count and duplicate rows (see below).
3. Calculated sales, profit and **profit margin** (profit divided by sales) by category, sub-category, discount band and market. Margins are used instead of raw profit so large categories aren't unfairly compared with small ones.
4. Grouped discounts into four bands (none, 1-20%, 21-40%, over 40%) to test whether discounting explains the losses.

### Data checks
- 51,290 rows, and 51,290 distinct rows, so no exact duplicates.
- Checked again ignoring the row ID: still 51,290, so no hidden duplicates.

## Findings

### By category
| Category | Order lines | Sales | Profit | Margin |
|---|---|---|---|---|
| Technology | 10,141 | 4,744,557 | 663,779 | 14.0% |
| Office Supplies | 31,273 | 3,787,070 | 518,474 | 13.7% |
| Furniture | 9,876 | 4,110,874 | 285,205 | 6.9% |

### By sub-category
Of 17 sub-categories, only **Tables** (in Furniture) loses money: 861 order lines, 757,042 in sales, **-64,083 profit (-8.5% margin)**. It pulls down the whole Furniture category.

### By discount band
| Discount | Order lines | Sales | Profit | Margin |
|---|---|---|---|---|
| None | 29,009 | 6,992,411 | 1,770,695 | 25.3% |
| 1-20% | 10,953 | 3,719,880 | 511,444 | 13.7% |
| 21-40% | 4,367 | 1,083,898 | -187,271 | -17.3% |
| Over 40% | 6,961 | 846,313 | -627,411 | -74.1% |

- Orders with no discount earn a 25.3% margin, which falls to 13.7% at 1-20%. **Above 20%, every band loses money.**
- Orders discounted by more than 20% make up about 22% of order lines but lose **814,682** in total. That is equal to about 36% of the profit earned by orders discounted by 20% or less.
- **Tables lose money in the 21-40% and over-40% discount bands**, which matches the company-wide pattern. The sub-category's losses come from heavy discounting.

### By market
No market loses money. The company-wide margin is 11.6% (1,467,458 profit on 12,642,501 of sales).

| Market | Order lines | Sales | Profit | Margin |
|---|---|---|---|---|
| EMEA | 5,029 | 806,161 | 43,898 | 5.4% |
| LATAM | 10,294 | 2,164,605 | 221,643 | 10.2% |
| Africa | 4,587 | 783,773 | 88,872 | 11.3% |
| APAC | 11,002 | 3,585,744 | 436,000 | 12.2% |
| US | 9,994 | 2,297,201 | 286,397 | 12.5% |
| EU | 10,000 | 2,938,089 | 372,830 | 12.7% |
| Canada | 384 | 66,928 | 17,817 | 26.6% |

- **EMEA is the weakest market**: a 5.4% margin, less than half the company-wide figure.
- **APAC earns the most profit** (436,000), followed by EU and the US.
- **Canada has the highest margin** (26.6%), but it is a very small market, with only 384 order lines.

## Recommendations
1. Cap discounts at 20% unless a manager signs them off.
2. Review discounting on Tables first, since it is the only sub-category making a loss.
3. Look into pricing and discounting in EMEA, the lowest-margin market.
4. Report profit margin by discount band every month, so heavy discounting is spotted early.

## Limitations
- This shows that heavy discounts and losses go together. It doesn't prove that discounting caused every loss.
- Canada has only 384 order lines, so its 26.6% margin is less reliable than the others.
- I did not test whether discounting explains EMEA's low margin.
- The discount bands are my own choice of cut-offs. Different bands could change the numbers a little.
- The currency and time period were not checked, and the data is a published sample dataset rather than a real company's records.

## Files
| File | What it is |
|---|---|
| `Global Superstore analysis.sql` | All the SQL queries, with notes |

<!-- Once the dashboard is built, upload dashboard.png and delete these comment markers:
![Dashboard](dashboard.png)
-->
