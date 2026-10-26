-- Carga de la categoría Estaciones de Gipuzkoa (provincia 20), trozo de la carga de Andalucía.
-- Origen: estaciones-pais-vasco.json (OpenStreetMap, ODbL, consulta del 2026-10-26, base 2026-10-25T21:21:21Z).
-- 79 filas. No toca nada existente: si el source_ref ya existe, no hace nada.
-- El municipio se asigna por código INE oficial (municipalities.official_code).
-- Transaccional: si falta la categoría o algún municipio, aborta sin cambios.

BEGIN;

CREATE TEMP TABLE _carga (
  source_ref text, name text, subtype text, muni_ine text, address text, postal_code text,
  latitude double precision, longitude double precision, location_precision text, location_source text
) ON COMMIT DROP;

INSERT INTO _carga VALUES
  ('catalogo-pais-vasco:estaciones:node-13186394514', 'Estación de tren de San Pelaio (Zarautz) – 2', 'Tren', '20079', '2', '20800', 43.28349, -2.16031, 'address', 'openstreetmap:node/13186394514'),
  ('catalogo-pais-vasco:estaciones:node-1330680970', 'Estación de tren de Brinkola (Legazpi) – Brinkola auzoa gunea', 'Tren', '20051', 'Brinkola auzoa gunea 14', '20220', 43.0188, -2.33447, 'address', 'openstreetmap:node/1330680970'),
  ('catalogo-pais-vasco:estaciones:node-13692644138', 'Estación de autobuses de Donostia (Donostia / San Sebastián) – Federico Garcia Lorca pasealekua', 'Autobús', '20069', 'Federico Garcia Lorca pasealekua', '20014', 43.31694, -1.97746, 'approximate', 'openstreetmap:node/13692644138'),
  ('catalogo-pais-vasco:estaciones:node-13775420638', 'Estación de Autobuses de Irún/Irungo Autobus Geltokia – Geltoki kalea', 'Autobús', '20045', 'Geltoki kalea', '20301', 43.33975, -1.80166, 'address', 'openstreetmap:node/13775420638'),
  ('catalogo-pais-vasco:estaciones:node-13827574219', 'Estación de tren de Arroa (Zestoa) – Karmengo Ama errepidea', 'Tren', '20027', 'Karmengo Ama errepidea', '20749', 43.27838, -2.27069, 'address', 'openstreetmap:node/13827574219'),
  ('catalogo-pais-vasco:estaciones:node-13827574222', 'Estación de tren de Toletxegain (Elgoibar) – Gabriel Krutzelaegi kalea', 'Tren', '20032', 'Gabriel Krutzelaegi kalea 10', '20870', 43.21768, -2.40869, 'address', 'openstreetmap:node/13827574222'),
  ('catalogo-pais-vasco:estaciones:node-13827574223', 'Estación de tren de Zumaia – Estazioko kalea', 'Tren', '20081', 'Estazioko kalea 1', '20750', 43.29154, -2.2518, 'address', 'openstreetmap:node/13827574223'),
  ('catalogo-pais-vasco:estaciones:node-13827574224', 'Estación de tren de Belaskoenea (Irun) – Marinel kalea', 'Tren', '20045', 'Marinel kalea 2', '20303', 43.33653, -1.80334, 'address', 'openstreetmap:node/13827574224'),
  ('catalogo-pais-vasco:estaciones:node-13827574225', 'Estación de tren de Irun Colon – Colon pasealekua', 'Tren', '20045', 'Colon pasealekua 52', '20301', 43.34094, -1.79606, 'address', 'openstreetmap:node/13827574225'),
  ('catalogo-pais-vasco:estaciones:node-13827574226', 'Estación de tren de Irun Ficoba – Iparralde hiribidea', 'Tren', '20045', 'Iparralde hiribidea 63', '20302', 43.34949, -1.78614, 'address', 'openstreetmap:node/13827574226'),
  ('catalogo-pais-vasco:estaciones:node-14023250584', 'Estación de tren de Pasaia – Gure Zumardia', 'Tren', '20064', 'Gure Zumardia 27', '20110', 43.3171, -1.91773, 'address', 'openstreetmap:node/14023250584'),
  ('catalogo-pais-vasco:estaciones:node-1672469482', 'Estación de tren de Azpeitia – Julian Elorza hiribidea', 'Tren', '20018', 'Julian Elorza hiribidea 10', '20730', 43.18583, -2.26127, 'address', 'openstreetmap:node/1672469482'),
  ('catalogo-pais-vasco:estaciones:node-2291368732', 'Estación de tren de Lasao (Azpeitia) – Izarraitz auzoa', 'Tren', '20018', 'Izarraitz auzoa 504', '20730', 43.2186, -2.25705, 'address', 'openstreetmap:node/2291368732'),
  ('catalogo-pais-vasco:estaciones:node-2381777955', 'Estación de tren de Anoeta – Apeadero lekua', 'Tren', '20010', 'Apeadero lekua 3', '20270', 43.16274, -2.0706, 'address', 'openstreetmap:node/2381777955'),
  ('catalogo-pais-vasco:estaciones:node-2463961443', 'Estación de tren de Itsasondo – Geltokiko bidea', 'Tren', '20047', 'Geltokiko bidea', '20249', 43.06837, -2.16253, 'address', 'openstreetmap:node/2463961443'),
  ('catalogo-pais-vasco:estaciones:node-2464005848', 'Estación de tren de Beasain – Barrendain plaza', 'Tren', '20019', 'Barrendain plaza 1', '20200', 43.0461, -2.20234, 'address', 'openstreetmap:node/2464005848'),
  ('catalogo-pais-vasco:estaciones:node-4107601629', 'Estación de autobuses de Iparbus-Herribus-Ekialdebus (Oiartzun) – Zelaimusu', 'Autobús', '20063', 'Zelaimusu 16', '20180', 43.29798, -1.88199, 'address', 'openstreetmap:node/4107601629'),
  ('catalogo-pais-vasco:estaciones:node-4194898831', 'Donostiako Autobus Geltokia (Donostia / San Sebastián) – Federico Garcia Lorca pasealekua', 'Autobús', '20069', 'Federico Garcia Lorca pasealekua', '20014', 43.31741, -1.97764, 'approximate', 'openstreetmap:node/4194898831'),
  ('catalogo-pais-vasco:estaciones:node-495990620', 'Estación de tren de Ordizia – San Bartolome kalea', 'Tren', '20076', 'San Bartolome kalea 9', '20240', 43.05261, -2.17922, 'address', 'openstreetmap:node/495990620'),
  ('catalogo-pais-vasco:estaciones:node-498214406', 'Estación de tren de Tolosa-Centro – Iturritxiki plaza', 'Tren', '20071', 'Iturritxiki plaza 1', '20400', 43.13947, -2.07416, 'address', 'openstreetmap:node/498214406'),
  ('catalogo-pais-vasco:estaciones:node-5034335247', 'Estación de tren de Lasarte-Oria – Donostia etorbidea', 'Tren', '20902', 'Donostia etorbidea 1', '20160', 43.27095, -2.02026, 'address', 'openstreetmap:node/5034335247'),
  ('catalogo-pais-vasco:estaciones:node-513291332', 'Estación de tren de Legorreta – San Miguel auzoa', 'Tren', '20052', 'San Miguel auzoa 10', '20250', 43.0858, -2.14096, 'address', 'openstreetmap:node/513291332'),
  ('catalogo-pais-vasco:estaciones:node-5171434483', 'Estación de tren de Oiartzun – Ganboxa bidea', 'Tren', '20063', 'Ganboxa bidea 8', '20180', 43.30862, -1.87916, 'address', 'openstreetmap:node/5171434483'),
  ('catalogo-pais-vasco:estaciones:node-5386020352', 'Estación de tren de Errekalde (Donostia / San Sebastián) – Errekalde hiribidea', 'Tren', '20069', 'Errekalde hiribidea 51', '20018', 43.27876, -2.00743, 'address', 'openstreetmap:node/5386020352'),
  ('catalogo-pais-vasco:estaciones:node-5386020353', 'Estación de tren de Añorga (Donostia / San Sebastián) – Añorga hiribidea', 'Tren', '20069', 'Añorga hiribidea', '20018', 43.29182, -1.99463, 'address', 'openstreetmap:node/5386020353'),
  ('catalogo-pais-vasco:estaciones:node-569074657', 'Estación de autobuses de Alegiko geltokia (Alegia) – Aralar bidea', 'Autobús', '20005', 'Aralar bidea 4', '20260', 43.10038, -2.09794, 'address', 'openstreetmap:node/569074657'),
  ('catalogo-pais-vasco:estaciones:node-578357399', 'Autobus geltokia (Oñati) – Unibertsitate etorbidea', 'Autobús', '20059', 'Unibertsitate etorbidea 9', '20560', 43.03415, -2.41608, 'address', 'openstreetmap:node/578357399'),
  ('catalogo-pais-vasco:estaciones:node-59613809', 'Estación de tren de Amaña (Eibar) – Amaña kalea', 'Tren', '20030', 'Amaña kalea 10', '20600', 43.18456, -2.48026, 'address', 'openstreetmap:node/59613809'),
  ('catalogo-pais-vasco:estaciones:node-6080884392', 'Estación de tren de Donostia / San Sebastián – Frantzia pasealekua', 'Tren', '20069', 'Frantzia pasealekua 22', '20001', 43.31774, -1.97693, 'address', 'openstreetmap:node/6080884392'),
  ('catalogo-pais-vasco:estaciones:node-6083584004', 'Estación de tren de Herrera (Donostia / San Sebastián) – Jose Elosegi Alkatearen hiribidea', 'Tren', '20069', 'Jose Elosegi Alkatearen hiribidea 136', '20017', 43.31962, -1.93671, 'address', 'openstreetmap:node/6083584004'),
  ('catalogo-pais-vasco:estaciones:node-608988814', 'Estación de tren de Legazpi – Geltoki hiribidea', 'Tren', '20051', 'Geltoki hiribidea 9', '20230', 43.05101, -2.33048, 'address', 'openstreetmap:node/608988814'),
  ('catalogo-pais-vasco:estaciones:node-6199583053', 'Estación de tren de Aia-Orio – Arratola Aldea', 'Tren', '20016', 'Arratola Aldea 6', '20810', 43.27421, -2.12646, 'address', 'openstreetmap:node/6199583053'),
  ('catalogo-pais-vasco:estaciones:node-620144475', 'Estación de tren de Zarautz – Lapurdi kalea', 'Tren', '20079', 'Lapurdi kalea 2', '20800', 43.28421, -2.17106, 'address', 'openstreetmap:node/620144475'),
  ('catalogo-pais-vasco:estaciones:node-642969646', 'Estación de tren de Ikaztegieta – San Lorentzo auzunea', 'Tren', '20044', 'San Lorentzo auzunea', '20267', 43.09396, -2.12549, 'address', 'openstreetmap:node/642969646'),
  ('catalogo-pais-vasco:estaciones:node-651274704', 'Estación de tren de Deba – Arakistain plaza', 'Tren', '20029', 'Arakistain plaza 6', '20820', 43.29364, -2.35555, 'address', 'openstreetmap:node/651274704'),
  ('catalogo-pais-vasco:estaciones:node-6690815030', 'Estación de tren de Fanderia (Errenteria) – Fanderia pasealekua', 'Tren', '20067', 'Fanderia pasealekua 13', '20100', 43.30826, -1.88885, 'address', 'openstreetmap:node/6690815030'),
  ('catalogo-pais-vasco:estaciones:node-6786551610', 'Estación de tren de Anoeta (Donostia / San Sebastián) – Anoeta pasealekua', 'Tren', '20069', 'Anoeta pasealekua 9', '20014', 43.30226, -1.97481, 'address', 'openstreetmap:node/6786551610'),
  ('catalogo-pais-vasco:estaciones:node-6786551611', 'Estación de tren de Loiola (Donostia / San Sebastián) – Urbia kalea', 'Tren', '20069', 'Urbia kalea 28', '20014', 43.31049, -1.96796, 'address', 'openstreetmap:node/6786551611'),
  ('catalogo-pais-vasco:estaciones:node-6786551612', 'Estación de tren de Intxaurrondo (Donostia / San Sebastián) – Zarategi pasealekua', 'Tren', '20069', 'Zarategi pasealekua', '20015', 43.31423, -1.95487, 'address', 'openstreetmap:node/6786551612'),
  ('catalogo-pais-vasco:estaciones:node-6786551615', 'Estación de tren de Galtzaraborda (Errenteria) – Geralekua kalea', 'Tren', '20067', 'Geralekua kalea 10', '20100', 43.31239, -1.90644, 'address', 'openstreetmap:node/6786551615'),
  ('catalogo-pais-vasco:estaciones:node-6786551617', 'Estación de tren de Errenteria – Pablo Iglesias kalea', 'Tren', '20067', 'Pablo Iglesias kalea 13', '20100', 43.31101, -1.89869, 'address', 'openstreetmap:node/6786551617'),
  ('catalogo-pais-vasco:estaciones:node-6786551619', 'Estación de tren de Bentak (Irun) – Elizatxo hiribidea', 'Tren', '20045', 'Elizatxo hiribidea 72', '20303', 43.33036, -1.81706, 'approximate', 'openstreetmap:node/6786551619'),
  ('catalogo-pais-vasco:estaciones:node-6856192695', 'Estación de tren de Loiola (Donostia / San Sebastián) – Aintzieta pasealekua', 'Tren', '20069', 'Aintzieta pasealekua 11', '20014', 43.30462, -1.96362, 'address', 'openstreetmap:node/6856192695'),
  ('catalogo-pais-vasco:estaciones:node-6856192696', 'Estación de tren de Gros (Donostia / San Sebastián) – Huertas kalea', 'Tren', '20069', 'Huertas kalea 4', '20001', 43.32194, -1.9733, 'address', 'openstreetmap:node/6856192696'),
  ('catalogo-pais-vasco:estaciones:node-6856192698', 'Estación de tren de Ategorrieta (Donostia / San Sebastián) – Joseba Zubimendi kalea', 'Tren', '20069', 'Joseba Zubimendi kalea 4', '20013', 43.32033, -1.95891, 'address', 'openstreetmap:node/6856192698'),
  ('catalogo-pais-vasco:estaciones:node-6856208612', 'Estación de tren de Andoain-Centro – Joakin Larreta etorbidea', 'Tren', '20009', 'Joakin Larreta etorbidea 23', '20140', 43.21553, -2.02031, 'address', 'openstreetmap:node/6856208612'),
  ('catalogo-pais-vasco:estaciones:node-6856208614', 'Estación de tren de Urnieta – San Juan kalea', 'Tren', '20072', 'San Juan kalea', '20130', 43.24786, -1.98813, 'address', 'openstreetmap:node/6856208614'),
  ('catalogo-pais-vasco:estaciones:node-6856208615', 'Estación de tren de Hernani-Centro – Oleta plaza', 'Tren', '20040', 'Oleta plaza 2', '20120', 43.26646, -1.97275, 'address', 'openstreetmap:node/6856208615'),
  ('catalogo-pais-vasco:estaciones:node-6856208616', 'Estación de tren de Martutene (Donostia / San Sebastián) – Martutene pasealekua', 'Tren', '20069', 'Martutene pasealekua', '20014', 43.29908, -1.95628, 'address', 'openstreetmap:node/6856208616'),
  ('catalogo-pais-vasco:estaciones:node-6856255906', 'Estación de tren de Zumarraga – Geltokietako plaza', 'Tren', '20080', 'Geltokietako plaza 4', '20700', 43.08702, -2.31988, 'address', 'openstreetmap:node/6856255906'),
  ('catalogo-pais-vasco:estaciones:node-6856255907', 'Estación de tren de Ormaiztegi – Ormaiztegi sakabanatua', 'Tren', '20062', 'Ormaiztegi sakabanatua 23', '20216', 43.04046, -2.25698, 'address', 'openstreetmap:node/6856255907'),
  ('catalogo-pais-vasco:estaciones:node-6856255913', 'Estación de tren de Ventas de Irún – Elizatxo hiribidea', 'Tren', '20045', 'Elizatxo hiribidea 74', '20303', 43.32975, -1.8184, 'approximate', 'openstreetmap:node/6856255913'),
  ('catalogo-pais-vasco:estaciones:node-6856255914', 'Estación de tren de Lezo-Rentería – Jaizkibel hiribidea', 'Tren', '20053', 'Jaizkibel hiribidea 2', '20100', 43.31596, -1.89931, 'address', 'openstreetmap:node/6856255914'),
  ('catalogo-pais-vasco:estaciones:node-6856255916', 'Estación de tren de Intxaurrondo (Donostia / San Sebastián) – Zubiaurre pasealekua', 'Tren', '20069', 'Zubiaurre pasealekua 62', '20015', 43.32015, -1.95277, 'address', 'openstreetmap:node/6856255916'),
  ('catalogo-pais-vasco:estaciones:node-6856255917', 'Estación de tren de Tolosa – Geltoki kalea', 'Tren', '20071', 'Geltoki kalea 2', '20400', 43.13564, -2.07914, 'address', 'openstreetmap:node/6856255917'),
  ('catalogo-pais-vasco:estaciones:node-6856255918', 'Estación de tren de Hernani – Florida auzoa', 'Tren', '20040', 'Florida auzoa 114', '20120', 43.2724, -1.96379, 'address', 'openstreetmap:node/6856255918'),
  ('catalogo-pais-vasco:estaciones:node-6856255919', 'Estación de tren de Andoain – Leizotz auzoa', 'Tren', '20009', 'Leizotz auzoa', '20140', 43.22214, -2.01562, 'address', 'openstreetmap:node/6856255919'),
  ('catalogo-pais-vasco:estaciones:node-6856255920', 'Estación de tren de Villabona-Zizurkil – Aurrera plaza', 'Tren', '20028', 'Aurrera plaza 5', '20150', 43.189, -2.05547, 'address', 'openstreetmap:node/6856255920'),
  ('catalogo-pais-vasco:estaciones:node-6856255945', 'Estación de tren de Alegia – San Juan kalea', 'Tren', '20005', 'San Juan kalea 6', '20260', 43.10188, -2.09722, 'address', 'openstreetmap:node/6856255945'),
  ('catalogo-pais-vasco:estaciones:node-718490529', 'Estación de tren de Mendaro – Jose Mª Linazasoro kalea', 'Tren', '20901', 'Jose Mª Linazasoro kalea 6', '20850', 43.2522, -2.3879, 'address', 'openstreetmap:node/718490529'),
  ('catalogo-pais-vasco:estaciones:node-7394440819', 'Estación de tren de Amara-Donostia (Donostia / San Sebastián) – Easo plaza', 'Tren', '20069', 'Easo plaza 9', '20006', 43.31268, -1.98153, 'address', 'openstreetmap:node/7394440819'),
  ('catalogo-pais-vasco:estaciones:node-8044450666', 'Estación de tren de Lugaritz (Donostia / San Sebastián) – Lugaritz pasealekua', 'Tren', '20069', 'Lugaritz pasealekua', '20018', 43.30243, -2.0007, 'address', 'openstreetmap:node/8044450666'),
  ('catalogo-pais-vasco:estaciones:node-8044686880', 'Estación de tren de Azitain (Eibar) – Barrena kalea', 'Tren', '20030', 'Barrena kalea', '20600', 43.1904, -2.45502, 'address', 'openstreetmap:node/8044686880'),
  ('catalogo-pais-vasco:estaciones:node-8044698613', 'Estación de tren de Unibertsitatea (Eibar) – Otaola hiribidea 24B', 'Tren', '20030', 'Otaola hiribidea 24B', '20600', 43.18069, -2.48727, 'address', 'openstreetmap:node/8044698613'),
  ('catalogo-pais-vasco:estaciones:node-8044702484', 'Estación de tren de Elgoibar – Trenbide kalea', 'Tren', '20032', 'Trenbide kalea 14', '20870', 43.2136, -2.41583, 'address', 'openstreetmap:node/8044702484'),
  ('catalogo-pais-vasco:estaciones:node-8044707160', 'Estación de tren de Eibar – Estaziño kalea', 'Tren', '20030', 'Estaziño kalea 19', '20600', 43.18711, -2.46567, 'address', 'openstreetmap:node/8044707160'),
  ('catalogo-pais-vasco:estaciones:node-8044735540', 'Estación de tren de Ardantza (Eibar) – Untzaga plaza', 'Tren', '20030', 'Untzaga plaza 11', '20600', 43.18462, -2.47425, 'address', 'openstreetmap:node/8044735540'),
  ('catalogo-pais-vasco:estaciones:node-8045179368', 'Estación de tren de Altza (Donostia / San Sebastián) – Felix Iranzo ibilbidea', 'Tren', '20069', 'Felix Iranzo ibilbidea', '20017', 43.31636, -1.93108, 'address', 'openstreetmap:node/8045179368'),
  ('catalogo-pais-vasco:estaciones:node-8045190140', 'Estación de tren de Usurbil – Usurbil barreiatua', 'Tren', '20073', 'Usurbil barreiatua', '20170', 43.26843, -2.05155, 'address', 'openstreetmap:node/8045190140'),
  ('catalogo-pais-vasco:estaciones:node-8879913468', 'Estación de autobuses de Ficoba (Irun) – Avenida Iparralde', 'Autobús', '20045', 'Avenida Iparralde', '20301', 43.34776, -1.78772, 'address', 'openstreetmap:node/8879913468'),
  ('catalogo-pais-vasco:estaciones:node-8879990780', 'Estación de autobuses de Belascoenea (Irun) – Balezaleen kalea', 'Autobús', '20045', 'Balezaleen kalea', '20303', 43.33664, -1.8023, 'address', 'openstreetmap:node/8879990780'),
  ('catalogo-pais-vasco:estaciones:node-8880023951', 'Estación de autobuses de Irun Colón – Colon pasealekua', 'Autobús', '20045', 'Colon pasealekua 50', '20301', 43.34078, -1.79619, 'address', 'openstreetmap:node/8880023951'),
  ('catalogo-pais-vasco:estaciones:node-9869698717', 'Estación de autobuses de Aireportua (Hondarribia) – Aireportuko kalea', 'Autobús', '20036', 'Aireportuko kalea', '20280', 43.35685, -1.79307, 'address', 'openstreetmap:node/9869698717'),
  ('catalogo-pais-vasco:estaciones:node-9882171870', 'Estación de tren de Irun – Geltoki kalea', 'Tren', '20045', 'Geltoki kalea', '20301', 43.3392, -1.80058, 'address', 'openstreetmap:node/9882171870'),
  ('catalogo-pais-vasco:estaciones:way-1093501551', 'Estación de tren de Gabiria – Orbeldegi auzoa', 'Tren', '20038', 'Orbeldegi auzoa 16', '20217', 43.05881, -2.27867, 'address', 'openstreetmap:way/1093501551'),
  ('catalogo-pais-vasco:estaciones:way-1236327927', 'Estación de autobuses de Ibargarai (Bergara) – Ibargarai hiribidea', 'Autobús', '20074', 'Ibargarai hiribidea 37', '20570', 43.11342, -2.41641, 'address', 'openstreetmap:way/1236327927'),
  ('catalogo-pais-vasco:estaciones:way-202974297', 'Euskotren autobus geltokia (Zumaia) – Estazioko kalea', 'Autobús', '20081', 'Estazioko kalea 29', '20750', 43.29216, -2.25035, 'address', 'openstreetmap:way/202974297'),
  ('catalogo-pais-vasco:estaciones:way-367496151', 'Estación de tren de Altzola (Elgoibar) – Donostia kalea', 'Tren', '20032', 'Donostia kalea 12', '20860', 43.23587, -2.39952, 'address', 'openstreetmap:way/367496151'),
  ('catalogo-pais-vasco:estaciones:way-421314734', 'Estación de tren de Zegama-Otzaurte', 'Tren', '20025', NULL, '20215', 42.93943, -2.26358, 'address', 'openstreetmap:way/421314734');

DO $$
DECLARE faltan text;
BEGIN
  IF NOT EXISTS (SELECT 1 FROM public.categories WHERE code = 'estaciones' AND name = 'Estaciones') THEN
    RAISE EXCEPTION 'Falta la categoría Estaciones.';
  END IF;
  SELECT string_agg(DISTINCT c.muni_ine, ', ') INTO faltan
  FROM _carga c
  WHERE NOT EXISTS (SELECT 1 FROM public.municipalities m JOIN public.provinces p ON p.id = m.province_id
                    WHERE m.official_code = c.muni_ine AND p.code = '20');
  IF faltan IS NOT NULL THEN
    RAISE EXCEPTION 'Faltan municipios de la provincia 20 con estos códigos INE: %', faltan;
  END IF;
END;
$$;

INSERT INTO public.establishments (
  province_id, municipality_id, category_id,
  name, normalized_name, subtype, address, postal_code,
  latitude, longitude, location_precision, location_source,
  source_ref, status
)
SELECT p.id, m.id, cat.id,
       c.name, lower(trim(c.name)), c.subtype, c.address, c.postal_code,
       c.latitude, c.longitude, c.location_precision, c.location_source,
       c.source_ref, 'active'
FROM _carga c
JOIN public.municipalities m ON m.official_code = c.muni_ine
JOIN public.provinces p ON p.id = m.province_id AND p.code = '20'
JOIN public.categories cat ON cat.code = 'estaciones'
ON CONFLICT DO NOTHING;

DO $$
DECLARE n integer;
BEGIN
  SELECT count(*) INTO n FROM public.establishments e WHERE e.source_ref IN (SELECT source_ref FROM _carga);
  IF n <> 79 THEN
    RAISE EXCEPTION 'Se esperaban 79 puntos de Estaciones en Gipuzkoa, hay %', n;
  END IF;
END;
$$;

COMMIT;
