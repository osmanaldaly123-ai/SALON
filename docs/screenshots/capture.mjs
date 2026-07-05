import { chromium, devices } from 'playwright';
import { mkdir } from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const baseUrl = process.env.APP_URL ?? 'http://localhost:8080';

const profiles = [
  {
    folder: 'android',
    device: devices['Pixel 7'],
    label: 'Android',
  },
  {
    folder: 'ios',
    device: devices['iPhone 14 Pro'],
    label: 'iPhone',
  },
];

async function wait(ms) {
  return new Promise((r) => setTimeout(r, ms));
}

async function captureScreens(page, outDir) {
  await wait(5000);

  await page.screenshot({
    path: path.join(outDir, '01-splash-or-login.png'),
    fullPage: false,
  });

  const guestButton = page.locator('button, [role="button"], flt-semantics').filter({
    hasText: /guest|زائر/i,
  });
  if (await guestButton.count()) {
    await guestButton.first().click({ force: true, timeout: 5000 }).catch(() => {});
    await wait(4000);
  }

  await page.screenshot({
    path: path.join(outDir, '02-home.png'),
    fullPage: false,
  });

  const salonsNav = page.getByText(/Salons|الصالونات/i).first();
  if (await salonsNav.count()) {
    await salonsNav.click({ force: true }).catch(() => {});
    await wait(2500);
    await page.screenshot({
      path: path.join(outDir, '03-salons.png'),
      fullPage: false,
    });
  }

  const profileNav = page.getByText(/Profile|الملف/i).last();
  if (await profileNav.count()) {
    await profileNav.click({ force: true }).catch(() => {});
    await wait(2500);
    await page.screenshot({
      path: path.join(outDir, '04-profile-guest.png'),
      fullPage: false,
    });
  }

  const dealsNav = page.getByText(/Deals|العروض/i).first();
  if (await dealsNav.count()) {
    await dealsNav.click({ force: true }).catch(() => {});
    await wait(2500);
    await page.screenshot({
      path: path.join(outDir, '05-deals.png'),
      fullPage: false,
    });
  }
}

async function main() {
  const browser = await chromium.launch({
    headless: true,
    args: [
      '--enable-webgl',
      '--use-angle=swiftshader',
      '--enable-accelerated-2d-canvas',
    ],
  });

  for (const profile of profiles) {
    const outDir = path.join(__dirname, profile.folder);
    await mkdir(outDir, { recursive: true });

    const context = await browser.newContext({
      ...profile.device,
      locale: 'ar-SA',
    });
    const page = await context.newPage();

    console.log(`Capturing ${profile.label} → ${outDir}`);
    await page.goto(baseUrl, { waitUntil: 'domcontentloaded', timeout: 60000 });
    await page.waitForSelector('flt-glass-pane, flutter-view', {
      timeout: 60000,
    });
    await wait(4000);
    await captureScreens(page, outDir);
    await context.close();
  }

  await browser.close();
  console.log('Done.');
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
