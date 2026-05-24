import urllib.request
import os

images = {
    'hero_1.jpg': 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?q=80&w=1000&auto=format&fit=crop',
    'hero_2.jpg': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=1000&auto=format&fit=crop',
    'hero_3.jpg': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=1000&auto=format&fit=crop',
    'prod_1.jpg': 'https://images.unsplash.com/photo-1590779033100-9f60a05a013d?q=80&w=600&auto=format&fit=crop',
    'prod_2.jpg': 'https://images.unsplash.com/photo-1582588147551-7893a74313dc?q=80&w=600&auto=format&fit=crop',
    'prod_3.jpg': 'https://images.unsplash.com/photo-1612080880345-09e4cb9c8c9a?q=80&w=600&auto=format&fit=crop',
    'prod_4.jpg': 'https://images.unsplash.com/photo-1546554137-f86b9593a222?q=80&w=600&auto=format&fit=crop',
    'prod_5.jpg': 'https://images.unsplash.com/photo-1546548970-71785318a30b?q=80&w=600&auto=format&fit=crop',
    'prod_6.jpg': 'https://images.unsplash.com/photo-1556910103-1c02745aae4d?q=80&w=600&auto=format&fit=crop',
    'prod_7.jpg': 'https://images.unsplash.com/photo-1505253716362-afaea1d3d1af?q=80&w=600&auto=format&fit=crop',
    'prod_8.jpg': 'https://images.unsplash.com/photo-1610486022068-15093df9fb9d?q=80&w=600&auto=format&fit=crop'
}

os.makedirs('assets/images', exist_ok=True)
req = urllib.request.build_opener()
req.addheaders = [('User-Agent', 'Mozilla/5.0')]
urllib.request.install_opener(req)

for name, url in images.items():
    try:
        urllib.request.urlretrieve(url, f'assets/images/{name}')
        print(f"Downloaded {name}")
    except Exception as e:
        print(f"Failed {name}: {e}")
